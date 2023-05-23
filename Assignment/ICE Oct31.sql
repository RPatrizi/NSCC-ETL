CREATE PROC sp_SubCategoryProduct (@SubCategoryName varchar(50))

as begin


SELECT ps.name as productsubcategory, pp.name as product
FROM Production.ProductSubcategory ps, Production.Product pp
WHERE ps.ProductSubcategoryID = pp.ProductSubcategoryID and ps.Name = @SubCategoryName

end;
Go

exec sp_SubCategoryProduct 'Mountain Bikes';
Go

--DROP PROC sp_readCategory;

--SELECT * FROM Production.ProductSubcategory;
--SELECT * FROM Production.Product;
--Go