-- Criar base de dados
CREATE DATABASE recipes;

-- Criar utilizador
CREATE USER IF NOT EXISTS 'internal_user'@'localhost' IDENTIFIED BY '#KgD32581kjhdjssdhdjkdhskahdskjjhasdkjjh';

-- Acesso à base de dados
GRANT ALL PRIVILEGES ON  recipes.* TO 'internal_user'@'localhost';
USE recipes;

-- Criar tabela de utilizadores
CREATE TABLE user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
	firstname VARCHAR(50) NOT NULL,
	lastname VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL, -- será encriptada
	email VARCHAR(100) NOT NULL UNIQUE,
	tokem VARCHAR(255) NOT NULL,
	active BOOLEAN DEFAULT FALSE,
    is_admin BOOLEAN DEFAULT FALSE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME,
	updated_by INT
	);

-- Criar tabela de produtos
CREATE TABLE product (
	id INT AUTO_INCREMENT PRIMARY KEY,
	product VARCHAR(50) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	created_by INT,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id)
	);

-- Criar tabela de tipos de receitas
CREATE TABLE type(
	id INT AUTO_INCREMENT PRIMARY KEY,
	type VARCHAR(50) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id)
	);
	
-- Criar tabela de tipos de grau de dificuldade
CREATE TABLE difficulty_level(
	id INT AUTO_INCREMENT PRIMARY KEY,
	level VARCHAR(50) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	created_by INT,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id)
	);
	
-- Criar tabela de paises
CREATE TABLE country(
	id INT AUTO_INCREMENT PRIMARY KEY,
	country VARCHAR(50) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	created_by INT,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id)
	);
	
-- Criar tabela de unidades
CREATE TABLE unit(
	id INT AUTO_INCREMENT PRIMARY KEY,
	unit VARCHAR(50) NOT NULL,
	weight INT,
	volume INT,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	created_by INT,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id)
	);

-- Criar tabela de cabeçalho de receitas
CREATE TABLE recipe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    preparation_time INT,
    servings INT,
	id_type INT,
	id_difficulty INT,
	id_country INT,
	id_user_approved INT,
	approved BOOLEAN DEFAULT FALSE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	created_by INT,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id),
	FOREIGN KEY (id_type) REFERENCES type(id),
	FOREIGN KEY (id_difficulty) REFERENCES difficulty(id),
	FOREIGN KEY (id_country) REFERENCES country(id)
	);
	
-- Criar tabela de grupos de ingredientes
CREATE TABLE group_ingredient (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_recipe INT,
    name VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	created_by INT,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id),
    FOREIGN KEY (id_recipe) REFERENCES recipe(id)
	);

-- Criar tabela de ingredientes
CREATE TABLE ingredient (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_group INT,
    product VARCHAR(255),
    quantity FLOAT,
    unit VARCHAR(50),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	created_by INT,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id),
    FOREIGN KEY (id_group) REFERENCES group_ingredient(id)
	);

-- Criar tabela de cabeçalhos de modo de preparação
CREATE TABLE group_preparation (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_recipe INT,
    name VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	created_by INT,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id),
    FOREIGN KEY (id_recipe) REFERENCES recipe(id) ON DELETE CASCADE
	);

-- Criar tabela de modo de preparação
CREATE TABLE preparation_step (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_group INT,
    step_description TEXT,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	created_by INT,
	updated_at DATETIME,
	updated_by INT,
	FOREIGN KEY (created_by) REFERENCES user(id),
    FOREIGN KEY (id_group) REFERENCES group_preparation(id) ON DELETE CASCADE
	);
