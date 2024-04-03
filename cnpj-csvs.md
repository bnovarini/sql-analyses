# Brazil CNPJ data for SQL
Readily accessing CNPJ data should be easy and mostly free. After all, it's publicly available.
However, after talking to a diverse set of founders and operators, I discovered folks were paying more than USD 50/mo to access structured and queryable versions of this information.

#### So if you're one of these people, have enough knowledge to upload CSV data to a SQL server and want to switch to free, keep reading.

## Context
The process of extracting, parsing and uploading CNPJ data for data analyzes can be broken down into 3 parts:

1. Downloading the publicly available data from: [http://200.152.38.155/CNPJ/](http://200.152.38.155/CNPJ/) (8 to 12 hours...download speed is excruciatingly slow)

2. Parsing the data into the easiest format to upload to a SQL server of your choice (less than 10 minutes with a Python script and some knowledge of the dataset)
3. Loading the data onto the server

To save folks from this process of downloading the public data, I've downloaded and parsed the csv with headers here for your convenience.

#### **[Download CNPJ csvs here][csv-data-link]** (latest update March 15th 2024)

## How to use this data with BigQuery
1. Upload the csvs into Cloud Storage
2. Open BigQuery and create a new dataset
3. Inside the dataset create the corresponding tables choosing "From Google Cloud Storage"
4. I highly suggest manually defining each table schema to ensure joins will work off the bat
5. Analyze at will using SQL
6. Bonus: if you don't want your queries to overload your BigQuery resource utilization, I highly suggest building creating a table that does the necessary joins directly on BigQuery so you can always use it for analyzes (not the original ones). You can build such table with:

`INSERT INTO project.dataset.table (columns, etc)
SELECT xxx
FROM xxx
JOIN xxx
Etc`

If you want to go the long route and download the data and set up a process behind the updates, I highly suggest checking out [this repo](https://github.com/rictom/cnpj-sqlite)


**Hope this helps!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [csv-data-link]:https://drive.google.com/drive/folders/1kfjZuEhbqmL53iXQXNwEVIU1PxWSxnYW?usp=drive_link
