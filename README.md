## API

I decided to use Python with Flask for RESTful API and PyMySQL for connection with the database.  
When a request comes, script connects to a free online SQL server, excecutes the queries and returns a response in CSV format.

### Run

Script should run without any modifications, you just need to install the required packages in case you don't already have them.  

### Test



## Database

For this project I chose to use SQL database with the following schema:  
![Schema](/pic/schema.PNG)  
Some fake data for every table.  
Customer table:  
![Customer](/pic/customer.PNG)  
Capmpaign table:  
![Campaign](/pic/campaign.PNG)  
Ad table:  
![Ad](/pic/ad.PNG)  
Impression table:  
![Impression](/pic/impression.PNG)  
  
You can also go to **[phpMyAdmin](http://www.phpmyadmin.co/index.php)** to see all the details regarding this database.  
```
Server: sql11.freemysqlhosting.net
Username: sql11224596
Password: uk9tTAEbRl
```  
There is also a backup .sql file in the project folder. 
