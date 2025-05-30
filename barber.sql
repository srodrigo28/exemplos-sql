https://database.build/db/si1assmojgfsylpf


preciso de uma tabela de 

barbearia campos:
id int8 auto-increment,
nome text,
cnpj int8,
cidade text,
bairro text,
telefone int8,
user_ref uuid, ref no auth

cliente campos: 
id int8 auto-increment,
nome text,
telefone int8,
barber_ref id int8,
user_ref uuid, ref no auth,

servicos campos:
id int8 auto-increment,
nome text,
barber_ref_id int8, 

agenda campos: 
id int8 auto-increment,
barber_ref_id int8, 
cliente_ref_id int8,
data_agenda date,
