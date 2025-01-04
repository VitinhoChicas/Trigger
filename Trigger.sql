/*82. Desenvolva um Trigger que ao ser excluído um registro da tabela produto apareça
uma mensagem que os dados do produto foram excluídos com sucesso.*/
CREATE OR REPLACE FUNCTION msg_produto_excluído()
RETURNS trigger AS $$
BEGIN

RAISE NOTICE 'Produto Excluído com sucesso!';
RETURN new;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER t_prod_excluido
AFTER DELETE
ON produto
FOR EACH ROW
EXECUTE PROCEDURE msg_produto_excluído();

DELETE FROM produto
WHERE codigo_produto=30

select * from produto
/*83. Crie um Trigger que ao inserir ou alterar um registro da tabela item do pedido
apareça uma mensagem informando que os dados foram alterados com sucesso.*/
drop trigger ex83T on item_do_pedido
create or replace function ex83()
returns trigger as $$ begin

Raise notice 'Dados alterados com sucesso';
return new;
end;
$$
language plpgsql;

create trigger ex83T
after insert or update 
on item_do_pedido
for EACH ROW
execute function ex83();

INSERT INTO item_do_pedido (num_pedido, codigo_produto, quantidade)
VALUES (137, 29, 15);

UPDATE item_do_pedido
SET quantidade = 20
WHERE num_pedido = 137 AND codigo_produto = 22;




/*84. Desenvolver um Trigger que ao ser alterado o salário do Vendedor insira o salário
antigo na tabela histórico do salário.*/

CREATE TABLE historico_salario (
    codigo_vendedor INTEGER NOT NULL,
    salario_antigo NUMERIC(10, 2),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_codigo_vendedor FOREIGN KEY (codigo_vendedor) REFERENCES vendedor(codigo_vendedor)
);

create or replace function ex84()
 returns trigger as $$ begin
 
   insert into historico_salario(codigo_vendedor, salario_antigo, data_alteracao)
   values (old.codigo_vendedor, old.salario_fixo, current_timestamp);
   
   return new;
   end;
   $$ language plpgsql;
   
 create trigger ex84T
 before update of salario_fixo
 on vendedor
 for each row
 execute function ex84();
 
 update vendedor 
set salario_fixo = 100
where codigo_vendedor = 209


select * from vendedor
select * from historico_salario

/*85. Crie um trigger que ao inserir um registro da tabela item do pedido, calcule e
armazene o seu subtotal.*/

alter table item_do_pedido
add column subtotal  numeric(10,2);

								  					


CREATE OR REPLACE FUNCTION calcular_subtotal()
RETURNS trigger AS $$
DECLARE
    preco_unitario numeric(10,2);
BEGIN 
 
    SELECT val_unit INTO preco_unitario 
    FROM produto 
    WHERE codigo_produto = NEW.codigo_produto;


    NEW.subtotal := NEW.quantidade * preco_unitario;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_calcular_subtotal
BEFORE INSERT 
ON item_do_pedido
FOR EACH ROW
EXECUTE FUNCTION calcular_subtotal();





INSERT INTO item_do_pedido (num_pedido, codigo_produto, quantidade)
VALUES (121, 22, 10);


SELECT * FROM item_do_pedido
SELECT * FROM item_do_pedido where num_pedido = 121

/*86. Crie um trigger que ao alterar um registro da tabela item do pedido, calcule e
atualize o seu subtotal.*/

CREATE OR REPLACE FUNCTION atualizar_subtotal()
RETURNS TRIGGER AS $$
BEGIN
    
    NEW.subtotal := NEW.quantidade * (SELECT val_unit FROM produto WHERE codigo_produto = NEW.codigo_produto);
    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_atualizar_subtotal
BEFORE UPDATE ON item_do_pedido
FOR EACH ROW
EXECUTE FUNCTION atualizar_subtotal();


UPDATE item_do_pedido
SET quantidade = 30  -- Nova quantidade
WHERE num_pedido = 121 AND codigo_produto = 31;

SELECT * FROM item_do_pedido WHERE num_pedido = 121 AND codigo_produto = 31;

/*87. Desenvolver um Trigger que ao ser alterado o endereço do cliente (endereço e
cep) insira o endereço antigo na tabela histórico de endereço.*/

create table historico_end (
  codigo_cliente Integer not null,
  cep_antigo char(8),
 endereco_antigo varchar(40),
	data_alteracao_end timestamp default current_timestamp,
	constraint fk_codigo_cliente foreign key (codigo_cliente) references cliente(codigo_cliente)
);

create or replace function ex87()
returns trigger as $$ begin

insert into historico_end(codigo_cliente,  cep_antigo, endereco_antigo, data_alteracao_end)
values (old.codigo_cliente, old.cep, old.endereco, current_timestamp);
 return new;
   end;
   $$ language plpgsql;

 create trigger ex87T
 before update of endereco, cep
 on cliente
 for each row
 execute function ex87();

update cliente 
set endereco = 'estrela oeste'
where codigo_cliente = 110

select * from cliente
select * from historico_end


/*88. Crie um Trigger que ao ser inserido um novo item do pedido atualize o campo
quantidade em estoque da tabela produto.*/

ALTER TABLE produto 
ADD quantidade_estoque numeric(10,2) DEFAULT 0;


CREATE OR REPLACE FUNCTION atualizar_estoque()
RETURNS TRIGGER AS $$
BEGIN
 
    UPDATE produto
    SET quantidade_estoque = quantidade_estoque - NEW.quantidade
    WHERE codigo_produto = NEW.codigo_produto;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_estoque
AFTER INSERT ON item_do_pedido
FOR EACH ROW
EXECUTE FUNCTION atualizar_estoque();

INSERT INTO item_do_pedido (num_pedido, codigo_produto, quantidade)
VALUES (148, 87, 10);

select * from produto

/*89. Crie um Trigger que ao ser alterado um item do pedido atualize o campo
quantidade em estoque da tabela produto.*/

CREATE OR REPLACE FUNCTION atualizar_estoque_apos_update()
RETURNS TRIGGER AS $$
BEGIN
   
    UPDATE produto
    SET quantidade_estoque = quantidade_estoque - OLD.quantidade + NEW.quantidade
    WHERE codigo_produto = NEW.codigo_produto;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_atualizar_estoque_apos_update
AFTER UPDATE OF quantidade ON item_do_pedido
FOR EACH ROW
EXECUTE FUNCTION atualizar_estoque_apos_update();


UPDATE item_do_pedido
SET quantidade = 15
WHERE num_pedido = 121 AND codigo_produto = 25;


select * from produto

