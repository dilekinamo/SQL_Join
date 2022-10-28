use NORTHWND

INSERT INTO Categories (CategoryName) VALUES ('Urunsuz')
INSERT INTO Products (ProductName) VALUES ('Kategorisiz')
INSERT INTO Employees (LastName,FirstName) VALUES ('Çaliskan','Süleyman')

--Soru 1. Ürünü olmayan kategorilerin isimlerini listeleyin
select CategoryName
from Categories left join Products
on Categories.CategoryID=Products.CategoryID
where Products.CategoryID is null

--Soru 2. Herhangi bir kategoriye dahil olmayan ürünlerin isimlerini listeyin
select ProductName
from Products left join Categories
on Products.CategoryID=Categories.CategoryID
where Products.CategoryID is null

--Asagidaki 2 sorgu sonuçlarinda CategoryName ve ProductName sütunlari yanyana gösterilecek sekilde listelenmesi beklenmektedir.
--Soru 3. Tüm kategorileri ve tüm ürünleri listeleyin
select CategoryName,ProductName
from Categories full join Products
on Categories.CategoryID=Products.CategoryID

--Soru 4. Ürünü olmayan kategorileri ve kategorisi olmayan ürünleri listeleyin
select CategoryName,ProductName
from Categories full join Products
on Categories.CategoryID=Products.CategoryID
where Products.ProductID is null or Categories.CategoryID is null

--Soru 5. Satis yapan çalisanlarin kaç adet ürün satisi yaptiklarini, çalisanin ad ve soyadi arasinda bir bosluk olacak sekilde 'Personel' isimli tek bir kolonda, sattigi ürün adedini 'Satis Adedi' baslikli kolonda olacak sekilde listeleyin
select FirstName+' '+LastName as 'Personel', sum(OD.Quantity)   as 'Satis Adedi'
from Employees E left join Orders O
on E.EmployeeID=O.EmployeeID 
inner join [Order Details] OD on O.OrderID=OD.OrderID
group by FirstName+' '+LastName

--Soru 6. Satis yapan çalisanlarin ne kadarlik satis yaptiklarini (toplam satis tutari), çalisanin ad ve soyadi arasinda bir bosluk olacak sekilde 'Personel' isimli tek bir kolonda, yaptigi toplam satis tutari 'Toplam Satis' baslikli kolonda olacak sekilde listeleyin
select FirstName+' '+LastName as 'Personel', sum(OD.Quantity*OD.UnitPrice)   as 'Toplam Satis'
from Employees E left join Orders O
on E.EmployeeID=O.EmployeeID 
inner join [Order Details] OD on O.OrderID=OD.OrderID
group by FirstName+' '+LastName

--Soru 7. Tüm çalisanlarin ne kadarlik satis yaptiklarini (toplam satis tutari), çalisanin ad ve soyadi arasinda bir bosluk olacak sekilde 'Personel' isimli tek bir kolonda, yaptigi toplam satis tutari 'Toplam Satis' baslikli kolonda olacak sekilde listeleyin
Soru 6´nin aynisi

--Soru 8. Hangi kategoriden toplam ne kadarlik siparis verilmis listeleyin
select CategoryName as 'Kategori',SUM(OD.Quantity*OD.UnitPrice)
from Orders O inner join [Order Details] OD
on O.OrderID=OD.OrderID inner join Products P on P.CategoryID=OD.ProductID
inner join Categories C on C.CategoryID=P.CategoryID
group by CategoryName


--Soru 9. Hangi müsteri toplam ne kadarlik siparis vermis
select C.CompanyName as 'Müsteri',SUM(OD.Quantity*OD.UnitPrice) as 'Toplam Satis'
from Customers C inner join Orders O on C.CustomerID=O.CustomerID
inner join [Order Details] OD on OD.OrderID=O.OrderID
group by C.CompanyName

--Soru 10. Hangi müsteri hangi kategorilerden siparis vermis 
select distinct CompanyName as 'Müsteri',CAT.CategoryName as 'Kategori'
from Customers C inner join orders O
on C.CustomerID=O.CustomerID inner join [Order Details] OD
on OD.OrderID=O.OrderID inner join Products P
on P.ProductID=OD.ProductID inner join Categories CAT
on CAT.CategoryID=P.CategoryID

--Soru 11. En çok satilan ürünün tedarikçisi hangi firma
select top 1 S.CompanyName as 'Tedarikci'
from Orders O left join [Order Details] OD on O.OrderID=OD.OrderID
inner join Products P on P.ProductID=OD.ProductID
inner join Suppliers S on S.SupplierID=P.SupplierID
--order by SUM(OD.Quantity) DESC
group by P.ProductName,S.CompanyName
order by SUM(OD.Quantity) desc


--Soru 12. Hangi üründen kaç adet satilmis
select P.ProductName as 'Ürün',SUM(OD.Quantity) as 'Ürün Adedi',S.CompanyName as 'Tedarikci'
from Orders O left join [Order Details] OD on O.OrderID=OD.OrderID
inner join Products P on P.ProductID=OD.ProductID
inner join Suppliers S on S.SupplierID=P.SupplierID
--order by SUM(OD.Quantity) DESC
group by P.ProductName,S.CompanyName
order by SUM(OD.Quantity) desc

--Soru 13. En çok satilan ürün hangisi
select top 1 P.ProductName as 'Ürün'
from Orders O left join [Order Details] OD on O.OrderID=OD.OrderID
inner join Products P on P.ProductID=OD.ProductID
inner join Suppliers S on S.SupplierID=P.SupplierID
--order by SUM(OD.Quantity) DESC
group by P.ProductName,S.CompanyName
order by SUM(OD.Quantity) desc

--Soru 14. Stokta 20 birim altinda kalan ürünlerin isimleri ve tedarikçi firma adini listeleyin 
select P.ProductName as 'Ürün',P.UnitsInStock as 'Adet', S.CompanyName as 'Tedarikci'
from Products P right join Suppliers S on P.ProductID=S.SupplierID
where P.UnitsInStock<20
order by P.UnitsInStock desc
 