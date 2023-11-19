![[images/Pasted image 20231031114905.png]]

![[images/Pasted image 20231031114923.png]]

![[images/Pasted image 20231031114952.png]]

![[images/Pasted image 20231031115015.png]]

![[images/Pasted image 20231031115023.png]]

![[images/Pasted image 20231031115049.png]]

![[images/Pasted image 20231031115410.png]]

![[images/Pasted image 20231031115433.png]]


imagn del frontend:

![[images/Pasted image 20231031115456.png]]

imagen de la base de datos:

![[images/Pasted image 20231031115509.png]]

Stages para desarrollar el script:


stage1:
- instalar git, php, apache, mariadb, previamente debe preguntarse si alguno o todos ya estan instalados
-creacion de usuario admin y de la app en mariadb
-los passwords de ambas credenciales debe pedirse por medio de stdin
-configurar apache para soporte de php

stage2:
- creacion de la estructura de la base de datos y data seeding
- copiar los fuentes a /var/www/html por medio de un git clone
- previo a la copia debe verificarse si ya existe el proyecto y si hay un git pull pendiente


condiciones:
- se requiere ser superusuario para ejecutarlo
