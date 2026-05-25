-- ============================================================================
-- DATA INSERTION
-- ============================================================================
USE ecommerce_refined;

-- Inserindo Clientes na tabela base
insert into clients (Address, ClientType) values 
('Rua Prata 258, Centro - Uberlândia MG', 'PF'),
('Av Rondon Pacheco 1500, Lidice - Uberlândia MG', 'PJ'),
('Rua Alameda 456, Carangola - Cidade das Flores', 'PF'),
('Av Nicomedes Alves dos Santos 800 - Uberlândia MG', 'PJ');

-- Inserindo os detalhes PF
insert into physical_client (idPhysicalClient, Fname, Minit, Lname, CPF, BirthDate) values
(1, 'Victor', 'H', 'Nogueira', '12345678901', '2003-10-11'),
(3, 'Maria', 'J', 'Decat', '23456789012', '2000-05-03');

-- Inserindo os detalhes PJ
insert into juridical_client (idJuridicalClient, SocialName, CNPJ) values
(2, 'Tech Solutions Ltda', '12345678000199'),
(4, 'Cargill Logistica S.A.', '98765432000188');

-- Inserindo Produtos
insert into product (Pname, Category, ProductDescription, Price, Rating, Size) values
('Fone de Ouvido Bluetooth', 'Eletrônico', 'Fone com cancelamento de ruído', 120.00, 4.5, null),
('Barbie Colecionável', 'Brinquedos', 'Boneca Barbie Edição Especial', 80.00, 4.8, null),
('Camiseta Algodão Premium', 'Vestimenta', 'Camiseta preta casual', 45.90, 4.0, 'G'),
('Introdução ao SQL', 'Livros', 'Livro técnico de Banco de Dados', 89.90, 4.9, null),
('Sofá 3 Lugares Retrátil', 'Móveis', 'Sofá cinza tecido suede', 1500.00, 3.5, '2.20m');

-- Inserindo Formas de Pagamento
insert into client_payments (idPaymentClient, PaymentType, TokenDetails) values
(1, 'Cartão de Crédito', 'TK-CRED-8521'),
(1, 'PIX', 'pix-key-victor'),
(2, 'Boleto', null),
(3, 'Cartão de Débito', 'TK-DEB-9632'),
(4, 'Cartão de Crédito', 'TK-CRED-1144');

-- Inserindo Entregas
insert into delivery (TrackingCode, DeliveryStatus, EstimatedDate) values
('BR123456789X', 'Em trânsito', '2026-06-01'),
('BR987654321Y', 'Entregue', '2026-05-20'),
('BR555666777Z', 'Em processamento', '2026-06-05');

-- Inserindo Pedidos
insert into orders (idOrderClient, idOrderDelivery, OrderStatus, OrderDescription, Freight, TotalValue) values
(1, 1, 'Confirmado', 'Compra pelo Aplicativo', 15.00, 135.00),
(1, 2, 'Confirmado', 'Upgrade de Equipamento', 0.00, 89.90),
(2, 3, 'Em processamento', 'Pedido Corporativo', 120.00, 1620.00),
(3, null, 'Em processamento', 'Compra Web', 10.00, 55.90);

-- Vinculando pagamentos aos pedidos (Split/Uso de Formas de Pagamento)
insert into order_payment_split (idOpOrder, idOpPayment, AmountPaid) values
(1, 1, 135.00),
(2, 2, 89.90),
(3, 3, 1620.00),
(4, 4, 55.90);

-- Inserindo Itens dos Pedidos
insert into productOrder (idPoProduct, idPoOrder, poQuantity, poStatus) values
(1, 1, 1, 'Disponível'),
(4, 2, 1, 'Disponível'),
(5, 3, 1, 'Disponível'),
(3, 4, 1, 'Disponível');

-- Inserindo Fornecedores (Atenção para o teste de Fornecedor que também é Vendedor)
insert into supplier (SocialName, CNPJ, Contact) values
('Tech Distributor', '11223344000155', '34999991111'),
('Moda e Cia', '55667788000122', '34999992222'),
('BrinqMundo Atacado', '99001122000133', '11988883333');

-- Inserindo Vendedores Terceirizados (Seller) - Vamos repetir o CNPJ da "Tech Distributor" para simular a regra de negócio
insert into seller (SocialName, CNPJ, CPF, Location) values
('Tech Distributor Varejo', '11223344000155', null, 'Uberlândia'),
('Loja Geek de Variedades', null, '44455566677', 'São Paulo');

-- Inserindo Locais de Estoque
insert into stock (StockLocation) values
('Depósito Central - Uberlândia'),
('Filial Nordeste'),
('Galpão Logístico Sul');

-- Vinculando Produtos a Estoques
insert into productStock (idPsProduct, idPsStock, AvailableQuantity, ReservedQuantity) values
(1, 1, 50, 2),
(2, 2, 30, 0),
(3, 1, 100, 5),
(4, 3, 15, 1),
(5, 1, 5, 1);

-- Vinculando Produtos a Fornecedores
insert into productSupplier (idPspProduct, idPspSupplier, CostPrice, DeliveryTime) values
(1, 1, 70.00, 5),
(3, 2, 20.00, 3),
(2, 3, 40.00, 4);


-- ============================================================================
-- QUERIES SQL 
-- ============================================================================

-- Qual o nome consolidado do cliente (seja PF ou PJ) e quantos pedidos cada um realizou?

select c.idClient, c.ClientType, COALESCE(CONCAT(pf.Fname, ' ', pf.Lname), pj.SocialName) as ClientName, COUNT(o.idOrder) as TotalOrders
from clients c LEFT JOIN physical_client pf on c.idClient = pf.idPhysicalClient LEFT JOIN juridical_client pj on c.idClient = pj.idJuridicalClient LEFT JOIN orders o on c.idClient = o.idOrderClient
GROUP BY c.idClient, c.ClientType, ClientName ORDER BY TotalOrders DESC;

-- Algum vendedor terceirizado também atua como fornecedor oficial na plataforma?

select s.idSupplier, s.SocialName as SupplierName, sel.idSeller, sel.SocialName as SellerName, s.CNPJ
from supplier s INNER JOIN seller sel on s.CNPJ = sel.CNPJ;

-- Quais produtos estão em estoque elevado (mais de 20 unidades disponíveis), qual o local do estoque e o valor total desse ativo fixado?

select p.idProduct, p.Pname as Product, st.StockLocation as Location, ps.AvailableQuantity as Qtd_Disponivel, p.Price as UnitPrice, (ps.AvailableQuantity * p.Price) as TotalStockValue 
from product p INNER JOIN productStock ps on p.idProduct = ps.idPsProduct INNER JOIN stock st on ps.idPsStock = st.idStock
WHERE ps.AvailableQuantity > 20 ORDER BY TotalStockValue DESC;

-- Quais categorias de produtos geraram um faturamento de pedidos acima de R$ 100,00?

select p.Category, SUM(po.poQuantity * p.Price) as TotalRevenue
from product p INNER JOIN productOrder po on p.idProduct = po.idPoProduct INNER JOIN orders o on po.idPoOrder = o.idOrder
WHERE o.OrderStatus != 'Cancelado' GROUP BY p.Category HAVING TotalRevenue > 100.00;


-- Exibir a relação completa de rastreamento de entregas dos pedidos dos clientes, mostrando o tipo de cliente e o status logístico atual.

select o.idOrder as Pedido, COALESCE(CONCAT(pf.Fname, ' ', pf.Lname), pj.SocialName) as Cliente,
    c.ClientType as Tipo, d.TrackingCode as CodigoRastreio, d.DeliveryStatus as StatusEntrega, d.EstimatedDate as DataEstimada
from orders o INNER JOIN clients c on o.idOrderClient = c.idClient LEFT JOIN physical_client pf on c.idClient = pf.idPhysicalClient 
LEFT JOIN juridical_client pj on c.idClient = pj.idJuridicalClient INNER JOIN delivery d on o.idOrderDelivery = d.idDelivery where d.DeliveryStatus IS NOT NULL;
