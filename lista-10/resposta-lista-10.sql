-- Nome: Bruno Said Alves de Souza
-- Matricula: 547860

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
	
-- Problema (1)

SELECT d.dnome
FROM empresa.departamento d
WHERE d.codigo IN (
	SELECT e.cdep
	FROM empresa.empregado e
	GROUP BY e.cdep
	HAVING AVG(salario) >= ALL (
		SELECT AVG(salario)
		FROM empresa.empregado e
		GROUP BY e.cdep
	)
)

-- Problema (2)

SELECT d.dnome, MAX(e.salario), MIN(e.salario), AVG(e.salario)
FROM empresa.departamento d, empresa.empregado e
WHERE d.codigo = e.cdep
GROUP BY d.dnome

-- Problema (3)

SELECT d.dnome, e.enome, tabEmpregado.qtd_empregado, tabProjeto.qtd_projeto, tabDUnidade.qtd_dunidade
FROM empresa.departamento d, empresa.empregado e,
	(
		SELECT d.codigo, count(*) as qtd_empregado
		FROM empresa.departamento d, empresa.empregado e
		WHERE d.codigo = e.cdep
		GROUP BY d.codigo
	) as tabEmpregado,
	(
		SELECT d.codigo, count(*) as qtd_projeto
		FROM empresa.departamento d, empresa.projeto p
		WHERE d.codigo = p.cdep
		GROUP BY d.codigo
	) as tabProjeto,
	(
		SELECT d.codigo, count(*) as qtd_dunidade
		FROM empresa.departamento d, empresa.dunidade du
		WHERE d.codigo = du.dcodigo
		GROUP BY d.codigo
	) as tabDUnidade
WHERE d.gerente = e.cpf AND d.codigo = tabEmpregado.codigo AND d.codigo = tabProjeto.codigo AND d.codigo = tabDUnidade.codigo

-- Problema (4)

SELECT
	tab.pnome
FROM
	(
		SELECT
			p.pnome, SUM(t.horas) as sum_horas
		FROM
			empresa.projeto p,
			empresa.tarefa t
		WHERE
			p.pcodigo = t.pcodigo
		GROUP BY
			p.pnome
	) as tab
WHERE tab.sum_horas >= ALL 
	(
		SELECT
			tab.sum_horas
		FROM 
			(
				SELECT
					p.pnome, SUM(t.horas) as sum_horas
				FROM
					empresa.projeto p,
					empresa.tarefa t
				WHERE
					p.pcodigo = t.pcodigo
				GROUP BY
					p.pnome
			) as tab
	)
	
-- Problema (5)

SELECT 
	tab1.pnome
FROM
	(	
		SELECT 
			p.pnome, 
			SUM(e.salario) AS sum_salario
		FROM 
			empresa.projeto p, 
			empresa.empregado e
		WHERE 
			p.cdep = e.cdep
		GROUP BY 
			p.pnome
	) AS tab1
WHERE
	tab1.sum_salario >= ALL
		(	
			SELECT
				tab2.sum_salario
			FROM
				(
					SELECT 
						p.pnome, 
						SUM(e.salario) AS sum_salario
					FROM 
						empresa.projeto p, 
						empresa.empregado e
					WHERE 
						p.cdep = e.cdep
					GROUP BY 
						p.pnome
				) AS tab2
		)
		
-- Problema (6)

SELECT 
	p.pnome, 
	e.enome, 
	tab1.sum_horas,
	tab2.qtd_empregado,
	tab3.sum_salario
FROM
	empresa.projeto p,
	empresa.empregado e,
	empresa.departamento d,
	(
		SELECT
			p.pcodigo, 
			SUM(t.horas) as sum_horas
		FROM
			empresa.tarefa t,
			empresa.projeto p			
		WHERE
			p.pcodigo = t.pcodigo
		GROUP BY
			p.pcodigo
	) AS tab1,
	(
		SELECT
			p.pcodigo,
			count(*) as qtd_empregado
		FROM
			empresa.projeto p,
			empresa.empregado e
		WHERE
			p.cdep = e.cdep
		GROUP BY
			p.pcodigo
	) AS tab2,
	(
		SELECT 
			p.pcodigo, 
			SUM(e.salario) AS sum_salario
		FROM 
			empresa.projeto p, 
			empresa.empregado e
		WHERE 
			p.cdep = e.cdep
		GROUP BY 
			p.pcodigo
	) AS tab3
WHERE
	d.codigo = p.cdep AND
	e.cpf = d.gerente AND
	p.pcodigo = tab1.pcodigo AND
	p.pcodigo = tab2.pcodigo AND
	p.pcodigo = tab3.pcodigo
	
-- Problema (7)

-- Nao existe coluna sobrenome nesse banco de dados, 
-- mas suponde que ela existe

SELECT
	e.enome
FROM
	empresa.empregado e,
	(
		(
			SELECT
				e.cpf
			FROM
				empresa.empregado e
			WHERE
			e.sobrenome = 'Silva'
		)
		INTERSECT
		(
			SELECT
				d.gerente AS cpf
			FROM
			empresa.departamento d
		)
	) AS tab
WHERE
	e.cpf = tab.cpf

-- Problema (8)

SELECT DISTINCT
	e.enome
FROM
	empresa.empregado e,
	empresa.departamento d,
	empresa.tarefa t
WHERE
	e.cpf = d.gerente AND
	t.cpf = d.gerente
	
-- Problema (9)

SELECT DISTINCT
	e.enome
FROM
	empresa.tarefa t,
	empresa.projeto p,
	empresa.empregado e,
	empresa.departamento d
WHERE
	t.cpf = e.cpf AND
	t.pcodigo = p.pcodigo AND
	e.cdep != p.cdep
	
-- Problema (10)

SELECT
	tab0.enome
FROM
	(
		SELECT
			tab.enome,
			count(*) AS num_projeto
		FROM
			(
				SELECT DISTINCT
					e.enome,
					p.pcodigo
				FROM
					empresa.empregado e,
					empresa.projeto p,
					empresa.tarefa t
				WHERE
					t.cpf = e.cpf AND
					t.pcodigo = p.pcodigo
			) AS tab
		GROUP BY
			tab.enome
	) AS tab0,
	(
		SELECT
			count(*) AS total_projeto
		FROM
			empresa.projeto p
	) as tab1
WHERE
	tab0.num_projeto = tab1.total_projeto

-- Problema (11)

SELECT
	e.enome, 
	e.salario, 
	d.dnome
FROM
	empresa.empregado e
		FULL OUTER JOIN 
			empresa.departamento d 
				ON e.cdep = d.codigo
ORDER BY 
	e.salario
	
-- Problema (12)
	
SELECT
	e.enome,
	tab1.enome,
	tab2.enome
FROM
	empresa.empregado e,
	(
		SELECT
			e1.cpf, 
			e2.enome
		FROM
			empresa.empregado e1
				LEFT OUTER JOIN
					empresa.empregado e2 ON
						e1.chefe = e2.cpf
	) AS tab1,
	(
		SELECT
			tab.cpf,
			e.enome
		FROM
			empresa.empregado e,
			(
				SELECT
					e.cpf, d.gerente
				FROM
					empresa.empregado e,
					empresa.departamento d
				WHERE
					e.cdep = d.codigo
			) AS tab
		WHERE
			e.cpf = tab.gerente
	) AS tab2
WHERE
	e.cpf = tab1.cpf AND
	tab1.cpf = tab2.cpf
	
-- Problema (13)

SELECT
	d.dnome
FROM
	empresa.departamento d,
	(
		SELECT
			d.codigo, AVG(e.salario)
		FROM
			empresa.empregado e,
			empresa.departamento d
		WHERE
			e.cdep = d.codigo
		GROUP BY
			d.codigo
			HAVING AVG(e.salario) >= ALL (
				SELECT
					AVG(e.salario)
				FROM
					empresa.empregado e
			)
	) AS tab
WHERE
	d.codigo = tab.codigo

-- Problema (14)

SELECT
	e.cpf
FROM
	empresa.empregado e,
	(
		SELECT
			d.codigo, AVG(e.salario)
		FROM
			empresa.empregado e,
			empresa.departamento d
		WHERE
			e.cdep = d.codigo
		GROUP BY
			d.codigo
	) AS tab
WHERE
	e.cdep = tab.codigo AND
	e.salario > tab.avg
	
-- Problema (15)

SELECT
	e.cpf
FROM
	empresa.dunidade du,
	empresa.empregado e
WHERE
	du.dcidade = 'Fortaleza' AND
	du.dcodigo = e.cdep
	
-- Problema (16)

SELECT
	e.cpf
FROM
	empresa.empregado e,
	(
		SELECT
			d.codigo, AVG(e.salario)
		FROM
			empresa.empregado e,
			empresa.departamento d
		WHERE
			e.cdep = d.codigo
		GROUP BY
			d.codigo
	) AS tab
WHERE
	e.cdep = tab.codigo AND
	e.salario = 2 * tab.avg
	
-- Problema (17)

SELECT
	e.enome
FROM
	empresa.empregado e
WHERE
	e.salario > 700.00 AND e.salario < 2800.00 
	
-- Problema (18)

SELECT
	d.dnome
FROM
	empresa.departamento d,
	empresa.projeto p,
	(
		(
			SELECT
				tab.pcodigo
			FROM
				(
					SELECT
						p.pcodigo, count(*) AS qtd_empregado
					FROM
						empresa.tarefa t,
						empresa.projeto p,
						empresa.empregado e
					WHERE
						e.cpf = t.cpf AND
						t.pcodigo = p.pcodigo
					GROUP BY
						p.pcodigo
				) AS tab
			WHERE
			tab.qtd_empregado > 50
		)
		INTERSECT
		(
			SELECT
				tab.pcodigo
			FROM
				(
					SELECT
						p.pcodigo, count(*) AS qtd_empregado
					FROM
						empresa.tarefa t,
						empresa.projeto p,
						empresa.empregado e
					WHERE
						e.cpf = t.cpf AND
						t.pcodigo = p.pcodigo
					GROUP BY
						p.pcodigo
				) AS tab
			WHERE
			tab.qtd_empregado < 5
		)
	) AS tab
WHERE
	tab.pcodigo = p.pcodigo AND
	p.cdep = d.codigo
	