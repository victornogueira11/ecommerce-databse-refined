-- ============================================================================
-- DESAFIO DE PROJETO: ESQUEMA RELACIONAL DE E-COMMERCE REFINADO (DIO)
-- Script: Definição de Estrutura (DDL)
-- Autor: Victor Hugo
-- ============================================================================

CREATE DATABASE IF NOT EXISTS ecommerce_refined;
USE ecommerce_refined;

-- Tabela Base de Clientes
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    ClientType ENUM('PF', 'PJ') NOT NULL
);

-- Especialização: Pessoa Física (PF)
CREATE TABLE physical_client (
    idPhysicalClient INT PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Minit CHAR(3),
    Lname VARCHAR(50) NOT NULL,
    CPF CHAR(11) NOT NULL,
    BirthDate DATE NOT NULL,
    CONSTRAINT unique_cpf UNIQUE (CPF),
    CONSTRAINT fk_physical_client FOREIGN KEY (idPhysicalClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

-- Especialização: Pessoa Jurídica (PJ)
CREATE TABLE juridical_client (
    idJuridicalClient INT PRIMARY KEY,
    SocialName VARCHAR(100) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    CONSTRAINT unique_cnpj UNIQUE (CNPJ),
    CONSTRAINT fk_juridical_client FOREIGN KEY (idJuridicalClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

-- Tabela de Produtos
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(100) NOT NULL,
    Category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Livros', 'Móveis') NOT NULL,
    ProductDescription VARCHAR(255),
    Price DECIMAL(10,2) NOT NULL,
    Classification_kids BOOLEAN DEFAULT FALSE,
    Rating FLOAT DEFAULT 0,
    Size VARCHAR(20)
);

-- Tabela de Formas de Pagamento do Cliente
CREATE TABLE client_payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idPaymentClient INT NOT NULL,
    PaymentType ENUM('Dinheiro', 'Boleto', 'Cartão de Crédito', 'Cartão de Débito', 'PIX') NOT NULL,
    TokenDetails VARCHAR(100),
    CONSTRAINT fk_payments_clients FOREIGN KEY (idPaymentClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

-- Tabela de Entregas
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    TrackingCode VARCHAR(50) NOT NULL,
    DeliveryStatus ENUM('Em processamento', 'Postado', 'Em trânsito', 'Entregue', 'Extraviado') DEFAULT 'Em processamento',
    EstimatedDate DATE,
    CONSTRAINT unique_tracking UNIQUE (TrackingCode)
);

-- Tabela de Pedidos
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT NOT NULL,
    idOrderDelivery INT,
    OrderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',
    OrderDescription VARCHAR(255),
    Freight DECIMAL(10,2) DEFAULT 0.00,
    TotalValue DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_orders_clients FOREIGN KEY (idOrderClient) REFERENCES clients(idClient),
    CONSTRAINT fk_orders_delivery FOREIGN KEY (idOrderDelivery) REFERENCES delivery(idDelivery) ON DELETE SET NULL
);

-- Relacionamento Pedidos e Formas de Pagamento
CREATE TABLE order_payment_split (
    idOpOrder INT,
    idOpPayment INT,
    AmountPaid DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idOpOrder, idOpPayment),
    CONSTRAINT fk_split_order FOREIGN KEY (idOpOrder) REFERENCES orders(idOrder) ON DELETE CASCADE,
    CONSTRAINT fk_split_payment FOREIGN KEY (idOpPayment) REFERENCES client_payments(idPayment)
);

-- Tabela de Fornecedores
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(100) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    Contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier_cnpj UNIQUE (CNPJ)
);

-- Tabela de Vendedores Terceirizados
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(100) NOT NULL,
    CNPJ CHAR(14),
    CPF CHAR(11),
    Location VARCHAR(100),
    CONSTRAINT unique_seller_cnpj UNIQUE (CNPJ),
    CONSTRAINT unique_seller_cpf UNIQUE (CPF)
);

-- Tabela de Estoques
CREATE TABLE stock (
    idStock INT AUTO_INCREMENT PRIMARY KEY,
    StockLocation VARCHAR(100) NOT NULL
);

-- Relação de Produto por Pedido (Itens do Pedido)
CREATE TABLE productOrder (
    idPoProduct INT,
    idPoOrder INT,
    poQuantity INT NOT NULL DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPoProduct, idPoOrder),
    CONSTRAINT fk_po_product FOREIGN KEY (idPoProduct) REFERENCES product(idProduct),
    CONSTRAINT fk_po_order FOREIGN KEY (idPoOrder) REFERENCES orders(idOrder) ON DELETE CASCADE
);

-- Relação de Produto e Estoque
CREATE TABLE productStock (
    idPsProduct INT,
    idPsStock INT,
    AvailableQuantity INT NOT NULL DEFAULT 0,
    ReservedQuantity INT NOT NULL DEFAULT 0,
    PRIMARY KEY (idPsProduct, idPsStock),
    CONSTRAINT fk_ps_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct),
    CONSTRAINT fk_ps_stock FOREIGN KEY (idPsStock) REFERENCES stock(idStock)
);

-- Disponibilização do Produto por Fornecedor
CREATE TABLE productSupplier (
    idPspProduct INT,
    idPspSupplier INT,
    CostPrice DECIMAL(10,2) NOT NULL,
    DeliveryTime INT,
    PRIMARY KEY (idPspProduct, idPspSupplier),
    CONSTRAINT fk_psp_product FOREIGN KEY (idPspProduct) REFERENCES product(idProduct),
    CONSTRAINT fk_psp_supplier FOREIGN KEY (idPspSupplier) REFERENCES supplier(idSupplier)
);

-- Produtos disponibilizados por Vendedor Terceirizado
CREATE TABLE productSeller (
    idPsProduct INT,
    idPsSeller INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPsProduct, idPsSeller),
    CONSTRAINT fk_pseller_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct),
    CONSTRAINT fk_pseller_seller FOREIGN KEY (idPsSeller) REFERENCES seller(idSeller)
);
