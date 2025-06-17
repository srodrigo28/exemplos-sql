create table app_data (
  id bigint primary key generated always as identity,
  created_at timestamp with time zone default now(),
  nome text,
  horario_inicio time,
  horario_saiu time,
  hora_total interval,
  hora_extra interval
);

create
or replace function update_hours () returns trigger as $$
BEGIN
    NEW.hora_total := NEW.horario_saiu - NEW.horario_inicio;
    IF NEW.hora_total > interval '8 hours' THEN
        NEW.hora_extra := NEW.hora_total - interval '8 hours';
    ELSE
        NEW.hora_extra := interval '0';
    END IF;
    RETURN NEW;
END;
$$ language plpgsql;

create trigger calculate_hours before insert
or
update on app_data for each row
execute function update_hours ();

-- view para calculo
create or replace view view_total_horas_mes as
select
  nome,
  sum(hora_extra) as total_horas_extras_mes
from
  app_data
group by
  nome;
