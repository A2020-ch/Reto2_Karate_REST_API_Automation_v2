@octoperf_api
Feature: Pruebas del Endpoint de Autenticación en Octoperf REST API (/public/users/login)

  Como un usuario de Octoperf
  Quiero autenticarme en el sistema a través del API
  Para validar el acceso correcto y el manejo de errores

  Background:
    * def userService = 'classpath:com/octoperf/users/public-user-service.feature'
    * def validUser = octoperfUsername
    * def validPassword = octoperfPassword
    * def invalidPassword = 'WrongPassword999'

  @CasoExitoso
  Scenario: Autenticación exitosa con credenciales válidas
    * match validUser == '#string? _.trim().length > 0'
    * match validPassword == '#string? _.trim().length > 0'
    * def result = call read(userService) { username: '#(validUser)', password: '#(validPassword)' }
    * match result.responseStatus == 200
    * match result.response.token.token == '#string? _.length > 0'
    * match result.response.token.expiresInSec == '#number? _ > 0'

  @CasoError
  Scenario: Error de autenticación con contraseña incorrecta
    * match validUser == '#string? _.trim().length > 0'
    * def result = call read(userService) { username: '#(validUser)', password: '#(invalidPassword)' }
    * match result.responseStatus == 200
    * match result.response['@type'] == 'LoginFailed'
    * match result.response.message == 'Invalid credentials'
