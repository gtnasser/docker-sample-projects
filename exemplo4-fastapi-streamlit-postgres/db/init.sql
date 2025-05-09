CREATE TABLE vendas (
    id SERIAL PRIMARY KEY,
    data_venda DATE NOT NULL,
    produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    quantidade INT NOT NULL
);

INSERT INTO vendas (data_venda, produto, categoria, valor, quantidade)
VALUES
  ('2025-01-15', 'Curso Python', 'Educacao', 197.00, 45),
  ('2025-01-20', 'Assinatura BI', 'Software', 89.90, 28),
  ('2025-02-05', 'Consultoria', 'Servicos', 1200.00, 3),
  ('2025-02-12', 'Curso SQL', 'Educacao', 147.00, 52),
  ('2025-03-01', 'Licenca Tableau', 'Software', 999.00, 15),
  ('2025-05-09', 'Curso Docker', 'Software', 14.90, 28);
