## API
I decided to use Python with Flask for RESTful API and PyMySQL for connection with the database.  
When a request comes, script connects to a free online SQL server, excecutes the queries and returns a response in CSV format.

### Run
Script should run without any modifications, you just need to install the required packages in case you don't already have them.  

### Test
I am using GET requests and plain text CSV responses for easier testing and faster development.  
Implemented methods:
* Specific campaign / All time
* All campaigns / Last week
* Customer info
* Campaign info
* Ad info

#### Specific campaign / All time
Request format:  
```
*url*/single-all/*campaign id*/*list of output metric columns separated with commas (order not important)*/
```
metrics: `impressions`, `interactions`, `clicks`, `swipes`, `pinches`, `touches`, `uniqueusers`

Examples:
```
example 1:
http://127.0.0.1:5002/single-all/12/swipes,clicks/

returns:
campaign,ad,swipes,clicks
12,1201,10,8
12,1202,1,9
12,1203,1,0
```
```
example 2:
http://127.0.0.1:5002/single-all/12/impressions,interactions,clicks,swipes,pinches,touches,uniqueusers/

returns:
campaign,ad,impressions,interactions,swipes,pinches,touches,clicks,uniqueusers
12,1201,3,21,10,1,2,8,3
12,1202,8,14,1,4,0,9,6
12,1203,1,8,1,2,5,0,1
```
```
example 3:
http://127.0.0.1:5002/single-all/abcdefg64694654564/swipes,clicks/

returns:
{"message": "Campaign ID must be a number"}
```

#### All campaigns / Last week
Request format is similar but without campaign ID:
```
*url*/all-week/*list of output metric columns separated with commas (order not important)*/
```
metrics: `impressions`, `interactions`, `clicks`, `swipes`, `pinches`, `touches`, `uniqueusers`

Examples:
```
example 1:
http://127.0.0.1:5002/all-week/impressions,clicks,pinches/

returns:
campaign,ad,date,impressions,pinches,clicks
11,1102,2018-03-01,1,0,1
11,1103,2018-02-28,1,0,0
11,1104,2018-02-28,1,1,1
11,1104,2018-03-01,1,0,1
11,1104,2018-03-03,2,1,1
12,1201,2018-02-27,1,0,0
12,1201,2018-03-02,1,0,0
12,1202,2018-02-28,3,0,3
12,1202,2018-03-02,1,2,1
12,1203,2018-03-01,1,2,0
```
```
example 2:
http://127.0.0.1:5002/all-week/impressions,interactions,clicks,swipes,pinches,touches,uniqueusers/

returns:
campaign,ad,date,impressions,interactions,swipes,pinches,touches,clicks,uniqueusers
11,1102,2018-03-01,1,1,0,0,0,1,1
11,1103,2018-02-28,1,0,0,0,0,0,1
11,1104,2018-02-28,1,4,0,1,2,1,1
11,1104,2018-03-01,1,1,0,0,0,1,1
11,1104,2018-03-03,2,4,0,1,2,1,2
12,1201,2018-02-27,1,3,3,0,0,0,1
12,1201,2018-03-02,1,5,3,0,2,0,1
12,1202,2018-02-28,3,4,1,0,0,3,3
12,1202,2018-03-02,1,3,0,2,0,1,0
12,1203,2018-03-01,1,8,1,2,5,0,1
```

#### Customer/Campaign/Ad info
Three methods, each returning information regarding specific Customer, Campaign or Ad.  
Request format:  
```
*url*/*customer,campaign or ad*-info/*id*/
```

Examples:
```
example 1:
http://127.0.0.1:5002/customer-info/1/

returns:
id,name,address
1,Spar,Jamova 105
```
```
example 2:
http://127.0.0.1:5002/customer-info/5/

returns:
{"message": "No data, check ID"}
```
```
example 3:
http://127.0.0.1:5002/campaign-info/11/

returns:
id,description,startdate,enddate,active,customerid
11,Fall2017,2017-09-01,2018-01-03,0,1
```
```
example 4:
http://127.0.0.1:5002/ad-info/1102/

returns:
id,name,startdate,enddate,active,campaignid
1102,Ad2Fall,2017-10-03,2017-11-03,0,11
```

## Database
For this project I chose to use SQL database with the following schema:  
![Schema](/pic/schema.PNG)  
This database design seemed suitable for this task because we can make new instance of it for every customer we have. It is also possible to have, for example, five instances and in each stored data for 25% of our customers. With that we can achieve faster response times and lower loads using multiple API instances and databases.  

Some fake data for every table.  
Customer table:  
![Customer](/pic/customer.PNG)  
Campaign table:  
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
