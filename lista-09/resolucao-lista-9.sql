-- Nome: Bruno Said Alves de Souza
-- Matricula: 547860

-- Problema (1)

-- Criando tabela 'Empregado'

CREATE TABLE empresa.empregado
(
	enome varchar(50) NOT NULL,
	cpf varchar(4) NOT NULL,
	endereco varchar(50),
	nasc timeStamp,
	sexo char,
	salario numeric(7, 2) NOT NULL,
	chefe varchar(4),
	cdep integer NOT NULL,
	PRIMARY KEY (cpf),
	FOREIGN KEY (chefe) 
		REFERENCES empresa.empregado (cpf) 
		ON DELETE SET NULL 
		DEFERRABLE INITIALLY DEFERRED
);

-- Criando tabela 'Departamento'

CREATE TABLE empresa.departamento
(
	dnome varchar(50) NOT NULL,
	codigo integer NOT NULL,
	gerente varchar(4) NOT NULL,
	PRIMARY KEY (codigo),
	FOREIGN KEY (gerente)
		REFERENCES empresa.empregado (cpf) 
		ON DELETE SET NULL
		DEFERRABLE INITIALLY DEFERRED
);

-- Adicionando chave estrangeira na tabela 'Empregado'

ALTER TABLE empresa.empregado 
	ADD FOREIGN KEY (cdep) 
		REFERENCES empresa.departamento (codigo) 
		ON DELETE CASCADE
		DEFERRABLE INITIALLY DEFERRED;

-- Criando tabela 'Projeto'

CREATE TABLE empresa.projeto
(
	pnome varchar(50) NOT NULL,
	pcodigo varchar(3) NOT NULL,
	cidade varchar(50) NOT NULL,
	cdep integer NOT NULL,
	PRIMARY KEY (pcodigo),
	FOREIGN KEY (cdep) 
		REFERENCES empresa.departamento (codigo) 
		ON DELETE CASCADE
);

-- Criando tabela 'Tarefa'

CREATE TABLE empresa.tarefa
(
	cpf varchar(4) NOT NULL,
	pcodigo varchar(3) NOT NULL,
	horas numeric(3, 1) NOT NULL,
	PRIMARY KEY (cpf, pcodigo),
	FOREIGN KEY (cpf)
		REFERENCES empresa.empregado (cpf)
		ON DELETE CASCADE,
	FOREIGN KEY (pcodigo) 
		REFERENCES empresa.projeto (pcodigo) 
		ON DELETE CASCADE
);

-- Criando tabela 'DUnidade'

CREATE TABLE empresa.dunidade
(
	dcodigo integer NOT NULL,
	dcidade varchar(50) NOT NULL,
	PRIMARY KEY (dcodigo, dcidade),
	FOREIGN KEY (dcodigo) 
		REFERENCES empresa.departamento (codigo) 
		ON DELETE CASCADE
);

-- Povoando tabela 'Empregado' e 'Departamento' juntas
-- para nao violar restricao de chave estrangeira

INSERT INTO empresa.empregado 
	VALUES ('Chiquin', '1234', 'rua 1, 1', '02/02/62', 'M', 10000.00, '8765', 3);
INSERT INTO empresa.empregado 
	VALUES ('Helenita', '4321', 'rua 2, 2', '03/03/63', 'F', 12000.00, '6543', 2);
INSERT INTO empresa.empregado 
	VALUES ('Pedrin', '5678', 'rua 3, 3', '04/04/64', 'M', 9000.00, '6543', 2);
INSERT INTO empresa.empregado 
	VALUES ('Valtin', '8765', 'rua 4, 4', '05/05/65', 'M', 15000.00, NULL, 4);
INSERT INTO empresa.empregado 
	VALUES ('Zulmira', '3456', 'rua 5, 5', '06/06/66', 'F', 12000.00, '8765', 3);
INSERT INTO empresa.empregado 
	VALUES ('Zefinha', '6543', 'rua 6, 6', '07/07/67', 'F', 10000.00, '8765', 2);
INSERT INTO empresa.departamento
	VALUES ('Pesquisa', 3, '1234');
INSERT INTO empresa.departamento
	VALUES ('Marketing', 2, '6543');
INSERT INTO empresa.departamento
	VALUES ('Administracao', 4, '8765');
	
-- Povoando tabela 'Projeto'

INSERT INTO empresa.projeto
	VALUES ('ProdutoA', 'PA', 'Cumbuco', 3);
INSERT INTO empresa.projeto
	VALUES ('ProdutoB', 'PB', 'Icapui', 3);
INSERT INTO empresa.projeto
	VALUES ('Informatizacao', 'Inf', 'Fortaleza', 4);
INSERT INTO empresa.projeto
	VALUES ('Divulgacao', 'Div', 'Morro Branco', 2);
	
-- Povoando tabela 'Tarefa'

INSERT INTO empresa.tarefa
	VALUES ('1234', 'PA', 30.0);
INSERT INTO empresa.tarefa
	VALUES ('1234', 'PB', 10.0);
INSERT INTO empresa.tarefa
	VALUES ('4321', 'PA', 5.0);
INSERT INTO empresa.tarefa
	VALUES ('4321', 'Div', 35.0);
INSERT INTO empresa.tarefa
	VALUES ('5678', 'Div', 40.0);
INSERT INTO empresa.tarefa
	VALUES ('8765', 'Inf', 32.0);
INSERT INTO empresa.tarefa
	VALUES ('8765', 'Div', 8.0);
INSERT INTO empresa.tarefa
	VALUES ('3456', 'PA', 10.0);
INSERT INTO empresa.tarefa
	VALUES ('3456', 'PB', 25.0);
INSERT INTO empresa.tarefa
	VALUES ('3456', 'Div', 5.0);
INSERT INTO empresa.tarefa
	VALUES ('6543', 'PB', 40.0);
	
-- Povoando 'DUnidade'

INSERT INTO empresa.dunidade
	VALUES (2, 'Morro Branco');
INSERT INTO empresa.dunidade
	VALUES (3, 'Cumbuco');
INSERT INTO empresa.dunidade
	VALUES (3, 'Prainha');
INSERT INTO empresa.dunidade
	VALUES (3, 'Taiba');
INSERT INTO empresa.dunidade
	VALUES (3, 'Icapui');
INSERT INTO empresa.dunidade
	VALUES (4, 'Fortaleza');
	
-- Problema (2)

-- 2.1

SELECT e.enome, e.salario
FROM empresa.empregado e;

-- 2.2

SELECT e.enome, e.salario
FROM empresa.empregado e
WHERE e.sexo = 'F';

-- 2.3

SELECT e.enome, e.salario
FROM empresa.empregado e
WHERE e.sexo = 'F' AND e.salario > 10000.00;

-- 2.4

SELECT count(*) as qtd_empregado
FROM empresa.empregado e;

-- 2.5

SELECT 
	MAX(e.salario) as max_salario, 
	MIN(e.salario) as min_salario,
	AVG(e.salario) as avg_salario
FROM empresa.empregado e;

-- 2.6

SELECT
	e.enome,
	e.salario
FROM
	empresa.empregado e,
	empresa.departamento d
WHERE
	e.cdep = d.codigo AND
	d.dnome = 'Marketing';
	
-- 2.7

SELECT DISTINCT
	t.cpf
FROM	
	empresa.tarefa t
	
-- 2.8

(
	SELECT e.cpf
	FROM empresa.empregado e
)
EXCEPT
(
	SELECT t.cpf
	FROM empresa.tarefa t
);
	
-- 2.9

SELECT DISTINCT
	e.enome
FROM
	empresa.tarefa t, 
	empresa.empregado e
WHERE
	e.cpf = t.cpf;
	
-- 2.10

SELECT
	e.enome
FROM
	empresa.empregado e,
	(
		(
			SELECT e.cpf
			FROM empresa.empregado e
		)
		EXCEPT
		(
			SELECT t.cpf
			FROM empresa.tarefa t
		)
	) as tab
WHERE 
	e.cpf = tab.cpf;

-- 2.11

SELECT 
	e.cpf
FROM
	empresa.empregado e,
	empresa.tarefa t
WHERE
	t.cpf = e.cpf AND t.horas > 30;
	
-- 2.12

SELECT
	e.enome
FROM
	empresa.empregado e,
	empresa.tarefa t
WHERE
	t.cpf = e.cpf AND t.horas > 30;
	
-- 2.13

SELECT
	d.dnome, e.enome
FROM
	empresa.empregado e,
	empresa.departamento d
WHERE 
	e.cpf = d.gerente;

-- 2.14

(
	SELECT
		e.cpf
	FROM
		empresa.empregado e,
		empresa.departamento d
	WHERE
		e.cdep = d.codigo AND
		d.dnome = 'Pesquisa'
)
UNION
(
	SELECT
		e.chefe
	FROM
		empresa.departamento d,
		empresa.empregado e
	WHERE
		d.codigo = e.cdep AND
		d.dnome = 'Pesquisa'
);
	
-- 2.15

SELECT DISTINCT
	p.pnome,
	p.cidade
FROM
	empresa.projeto p,
	(
		SELECT
			p.pcodigo
		FROM
			empresa.tarefa t,
			empresa.projeto p
		WHERE 
			t.pcodigo = p.pcodigo AND
			t.horas > 30
	) as tab
WHERE
	tab.pcodigo = p.pcodigo;
	
-- 2.16

SELECT
	e.enome,
	e.nasc
FROM
	empresa.empregado e,
	empresa.departamento d
WHERE 
	e.cpf = d.gerente;
	
-- 2.17

SELECT
	e.enome,
	e.endereco
FROM
	empresa.empregado e,
	empresa.departamento d
WHERE
	d.dnome = 'Pesquisa' AND
	e.cdep = d.codigo;
	
-- 2.18

SELECT
	p.pcodigo,
	d.dnome,
	e.enome
FROM
	empresa.projeto p,
	empresa.departamento d,
	empresa.empregado e
WHERE
	p.cidade = 'Icapui' AND
	d.codigo = p.cdep AND
	e.cpf = d.gerente;
	
-- 2.19

SELECT
	e.enome,
	e.sexo
FROM
	empresa.empregado e,
	empresa.departamento d
WHERE
	e.cpf = d.gerente;
	
-- 2.20

SELECT
	e.enome,
	e.sexo
FROM
	empresa.empregado e,
	(
		(
			SELECT
				e.cpf
			FROM
				empresa.empregado e
		)
		EXCEPT
		(
			SELECT
				d.gerente
			FROM
				empresa.departamento d
		)
	) as tab
WHERE
	e.cpf = tab.cpf;
	