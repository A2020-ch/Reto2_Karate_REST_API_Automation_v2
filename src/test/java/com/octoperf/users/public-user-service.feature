Feature: Reusable API Service - Octoperf Public Users

  Background:
    * url baseUrl
    * path '/public/users'

  @login
  Scenario: Realizar login de usuario publico
    # Parametros esperados: username, password
    Given path '/login'
    And param username = username
    And param password = password
    When method post
