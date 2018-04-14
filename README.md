# A music store application with Ruby/Sinatra and PL/SQL

## This application aims at helping the manager of a music store to perform :
- CRUD operations on genres of music
- CRUD operations on artists
- CRUD operations on albums
- CRUD operations on suppliers
- CRUD operations on clients
- CRUD operations on purchase orders
- CRUD operations on sale orders


## Technical stack

Frontend : HTML 5 + CSS 3

Backend : Ruby with the Sinatra MVC freamework

Data persistence : PL/SQL database

## At a glance

### CRUD operations on genres of music
- Genres can be searched by name.
- For each genre a link to filter its albums is provided.
![Optional Text](./documentation/5_screenshots/genres.png)

### CRUD operations on artists
- Artists can be searched by name.
- For each artist a link to filter his/her albums is provided.
![Optional Text](./documentation/5_screenshots/artists.png)

### CRUD operations on albums
- Albums can be searched by atist's name, title, genre and lstock level.
- Depending on their stock level settings, the current stock level of an album can be either displayed in green, yellow or red.
- For each album in stock, some links allow to reach :
  - The album profile
  - The artist profile
  
> Diplay mode list.
![Optional Text](./documentation/5_screenshots/albums_in_stock.png)

> Diplay mode grid.
![Optional Text](./documentation/5_screenshots/albums_grid_presentation.png)

> Filter activated on albums whose stock is running low.
![Optional Text](./documentation/5_screenshots/albums_low_in_stock.png)

> Modify operation on an album
![Optional Text](./documentation/5_screenshots/album_modification.png)

### CRUD operations on suppliers
- Suppliers can be searched by name.
- The link "sales" open the page which displays all the supplier's sales. 
![Optional Text](./documentation/5_screenshots/supliers.png)

### CRUD operations on customers
- Customers can be searched by name.
- The link "sales" open the page which displays all the customer's sales. 
![Optional Text](./documentation/5_screenshots/customers.png)

### CRUD operations on purchase orders
> Depending on its status "OnGoing" or "Done" a purchase order can be modified and deleted or not.
![Optional Text](./documentation/5_screenshots/purchase_order_list.png)
> A purchase order consists on : 
- Selecting a supplier
- Adding albums in the bascket with their quantity
- Checking out the basket
![Optional Text](./documentation/5_screenshots/purchase_order_modification.png)

### CRUD operations on sale orders
> Depending on its status "OnGoing" or "Done" a sale order can be modified and deleted or not.
![Optional Text](./documentation/5_screenshots/sales_orders_list.png)
> A sale order consists on : 
- Selecting a customer
- Adding albums in the bascket with their quantity
- Checking out the basket
![Optional Text](./documentation/5_screenshots/sale_order_modification.png)
