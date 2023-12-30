Feature: Creación de Usuario en Swagger Petstore

  Background:
    * url 'https://petstore.swagger.io/v2'

  Scenario Outline: Crear un nuevo usuario
    Given path '/user/createWithArray'
    And request [{ "id": <id>, "username": "<username>", "firstName": "<firstName>", "lastName": "<lastName>",  "email": "<email>",  "password": "<password>",  "phone": "<phone>",  "userStatus": <userStatus> }]
    When method post
    And def statusCode = responseStatus
    And match response.message == 'ok'
    And match statusCode == 200
    Then if (statusCode == 200) karate.log('Usuario creado correctamente')
    * if (statusCode== 500) karate.log('Servidor no responde')
    Examples:
      |id  |username|firstName    |lastName    |email                |password    |phone    |userStatus|
      |1008|User1008|firstName1008|lastName1008|email1008@hotmail.com|password1008|1002-1004|1         |
      |1009|User1009|firstName1009|lastName1005|email1009@hotmail.com|password1009|1002-1005|1         |
      |1010|User1010|firstName1010|lastName1006|email1010@hotmail.com|password1010|1002-1006|1         |
      |1011|User1011|firstName1011|lastName1007|email1011@hotmail.com|password1011|1002-1007|1         |

  Scenario Outline: Buscar Usuario por nombre de usuario
    Given path '/user/<username>'
    When method get
    Then if (responseStatus == 200) karate.log('Usuario encontrado correctamente')
    * if (responseStatus== 500) karate.log('Servidor no responde')
    * if (responseStatus == 400) karate.log('Invalid user supplied')
    * if (responseStatus == 404) karate.log('User not found')
    Examples:
      |username|
      |User1003|
      |User1005|
      |User1006|
      |User1007|

  Scenario Outline: Actualizar Usuario
    Given path '/user/<username>'
    When method get
    Then if (response.code == 400) karate.log('Invalid user supplied')
    * if (response.code == 404) karate.log('User not found')
    And path '/user/<username>'
    And def user = response
    And karate.log('Contenido del objeto user:', user)
    And request  { "id": "#(user.id)",  "username": "#(user.username)",  "firstName": "<firstName>",  "lastName": "#(user.lastName)", "email": "<newemail>", "password": "#(user.password)", "phone": "#(user.phone)", "userStatus": "#(user.userStatus)" }
    And header Content-Type = 'application/json'
    When method put
    Then if (responseStatus == 200) karate.log('Usuario actualizado correctamente')
    * if (responseStatus == 400) karate.log('Invalid user supplied')
    Examples:
      |username|firstName|newemail                |
      |User1003|1003User |1003user@hotmail.com    |

  Scenario Outline: Delete Usuario
    Given path '/user/<username>'
    When method delete
    Then if (responseStatus == 204) karate.log('Usuario eliminado correctamente')
    Then if (responseStatus == 400) karate.log('Invalid user supplied')
    * if (responseStatus == 404) karate.log('User not found')
    Examples:
      |username|
      |User1003|


