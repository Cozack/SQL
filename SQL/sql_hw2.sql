--1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT * FROM client WHERE LENGTH(FirstName)<6

--2. +Вибрати львівські відділення банку.+
SELECT * FROM department WHERE DepartmentCity='Lviv'

--3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT * FROM client WHERE Education='high' ORDER BY LastName

--4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.

SELECT * FROM application ORDER BY idApplication DESC LIMIT 5


--5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
SELECT * FROM client WHERE LastName LIKE '%OV' OR LastName LIKE '%OVA'

--6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.

SELECT client.idClient,
client.FirstName,
client.LastName,
department.DepartmentCity
 FROM client
JOIN  department ON client.Department_idDepartment = department.idDepartment WHERE DepartmentCity = 'Kyiv';


--7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
SELECT firstname,passport FROM client ORDER BY FirstName;

--8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.

SELECT * FROM client cl
JOIN application app ON cl.idClient = app.Client_idClient
WHERE app.CreditState = 'not returned'
AND  app.Sum >5000
AND app.Currency = 'Gryvnia';

--9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.

SELECT DISTINCT COUNT(FirstName) FROM client
JOIN department ON client.Department_idDepartment = department.idDepartment
WHERE department.DepartmentCity = 'lviv';


--10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.

SELECT Client_idClient, MAX(Sum) FROM application GROUP BY Client_idClient;

--________________________________________--

SELECT application.sum,
application.Currency,
client.FirstName,
client.LastName
 from application
JOIN client ON application.Client_idClient = client.idClient
ORDER BY FirstName,Sum DESC,Currency;

--11. Визначити кількість заявок на крдеит для кожного клієнта.

SELECT client.firstname, client.LastName,
count(application.Client_idClient)
 FROM client
JOIN application ON client.idClient = application.Client_idClient
 GROUP BY application.Client_idClient

--12. Визначити найбільший та найменший кредити.

SELECT max(sum), min(sum) FROM application ;

--_________________________________________________
SELECT  cl.FirstName,
cl.LastName,
max(app.sum),
min(app.sum),
 app.Currency
FROM application app
JOIN client cl ON app.Client_idClient = cl.idClient
 GROUP BY cl.FirstName ,Currency ,sum;

--13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.

SELECT client.firstname, client.LastName,
count(application.Client_idClient)
 FROM client
JOIN application ON client.idClient = application.Client_idClient
WHERE client.Education = 'high'
 GROUP BY application.Client_idClient

--14. Вивести дані про клієнта, в якого середня сума кредитів найвища.

SELECT client.firstname,
avg(application.sum) max_avg_sum
 FROM client
JOIN application ON client.idClient = application.Client_idClient
GROUP BY client.FirstName
ORDER BY max_avg_sum DESC LIMIT 1;


--15. Вивести відділення, яке видало в кредити найбільше грошей

SELECT d.idDepartment, sum(app.sum) from department d
JOIN client cl ON d.idDepartment = cl.Department_idDepartment
JOIN application app ON app.Client_idClient = cl.idClient
GROUP BY d.idDepartment  ORDER BY app.sum LIMIT 1;

--16. Вивести відділення, яке видало найбільший кредит.

SELECT d.idDepartment, max(app.sum) from department d
JOIN client cl ON d.idDepartment = cl.Department_idDepartment
JOIN application app ON app.Client_idClient = cl.idClient
GROUP BY d.idDepartment ORDER BY app.sum ASC Limit 1;

--17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.

UPDATE application
JOIN client ON application.Client_idClient = client.idClient
SET application.sum = 6000 WHERE client.education = 'high'
AND application.currency ='Gryvnia';


--18. Усіх клієнтів київських відділень пересилити до Києва.

UPDATE client cl
JOIN department dep ON cl.Department_idDepartment = dep.idDepartment
SET cl.city = 'Kyiv' WHERE dep.DepartmentCity = 'Kyiv';

--19. Видалити усі кредити, які є повернені.

DELETE FROM application
WHERE CreditState = 'Returned';


--20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.

DELETE app FROM application app
JOIN client ON app.Client_idClient = client.idClient
WHERE client.LastName LIKE '_[e,o,i,a,u]%'

--Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000

SELECT d.idDepartment, d.DepartmentCity, sum(app.sum) AS summa from department d
JOIN client cl ON d.idDepartment = cl.Department_idDepartment
JOIN application app ON app.Client_idClient = cl.idClient
WHERE d.DepartmentCity = 'Lviv'
GROUP BY d.idDepartment HAVING summa > 5000;




--Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000

SELECT cl.firstname, cl.lastname, app.CreditState FROM client cl
JOIN application app ON cl.idClient = app.Client_idClient
WHERE app.CreditState = 'Returned' AND app.SUM > 5000;



/* Знайти максимальний неповернений кредит.*/

SELECT max(sum), Client_idClient, CreditState  FROM application
WHERE CreditState = 'Not returned';


/*Знайти клієнта, сума кредиту якого найменша*/

SELECT Client_idClient, MIN(Sum) AS summa,FirstName,LastName FROM application
JOIN client ON application.Client_idClient = client.idClient
  GROUP BY Client_idClient ORDER BY summa ASC LIMIT 1;


/*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/

SELECT sum, Client_idClient  FROM application
WHERE sum > (SELECT AVG(sum) FROM application);

/*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/

SELECT * FROM client
WHERE city = (SELECT cl.City FROM application app JOIN client cl ON cl.idClient = app.Client_idClient
GROUP BY app.Client_idClient
ORDER BY COUNT(idApplication) DESC LIMIT 1);

--#місто чувака який набрав найбільше кредитів

SELECT cl.firstname, cl.LastName,
count(app.Client_idClient) AS max_credits, cl.city
 FROM client cl
JOIN application app ON cl.idClient = app.Client_idClient
 GROUP BY app.Client_idClient
 ORDER BY max_credits DESC LIMIT 1;
