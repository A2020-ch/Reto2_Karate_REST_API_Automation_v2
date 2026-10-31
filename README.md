# Karate DSL + BDD: Octoperf REST API Automation

Este proyecto valida el endpoint `POST /public/users/login` de Octoperf con **Karate DSL**, que proporciona el cliente HTTP REST y soporte BDD/Gherkin. El escenario invoca un feature reutilizable de servicio para separar la llamada HTTP de las aserciones.

La referencia del contrato es el [Swagger publico de Octoperf](https://api.octoperf.com/swagger-ui/index.html), grupo **System - Public Users**.

---

## 🎯 Escenarios Coberturados

1. **[Caso Exitoso] Usuario Válido y Password Correcto:**
   - Envío de `username` y `password` válidos como parámetros de consulta vía `POST /public/users/login`.
   - Validar HTTP status `200 OK`.
   - Validar que `token` exista, sea texto y no esté vacío.

2. **[Caso Error] Usuario Válido y Password Incorrecto:**
   - Enviar el correo de una cuenta Octoperf existente y una contraseña incorrecta.
   - Validar la respuesta de rechazo y el mensaje.

### Contrato del error y diferencia con Swagger

El Swagger describe `RestServerError` con las propiedades `type` y `message` para respuestas HTTP de error. Sin embargo, al enviar una contraseña incorrecta al endpoint, la respuesta observada es `200 OK` con `{"@type":"LoginFailed","message":"Invalid credentials"}`. Por eso el escenario comprueba el discriminador real `@type` y `message`; no afirma que exista una propiedad `type` que esta respuesta no devuelve. El endpoint puede devolver `type` en otros errores HTTP definidos por Swagger.

## Estructura de la prueba

- `public-user-service.feature`: encapsula URL, ruta, parámetros de consulta y método HTTP.
- `octoperf_login.feature`: contiene los escenarios BDD y valida status y body.
- `OctoperfApiTest.java`: ejecuta la suite con JUnit 5.

---

## 🚀 Pasos para Instalación y Ejecución

### 1. Requisitos Previos
- **Java JDK**: 11 o superior
- **Apache Maven**: 3.8+ o superior
- Una cuenta de Octoperf válida para el escenario de autenticación exitosa.

Configura las credenciales de prueba como variables de entorno antes de ejecutar:

```powershell
$env:OCTOPERF_USERNAME = "usuario-de-prueba"
$env:OCTOPERF_PASSWORD = "contraseña-de-prueba"
```

Usa una cuenta Octoperf de prueba creada con ese correo. Las credenciales deben ser reales para validar el escenario exitoso; no las guardes en el repositorio ni compartas reportes que puedan contenerlas. El escenario negativo reutiliza el correo y sustituye la contraseña por una incorrecta.

Opcionalmente, puedes reemplazar la URL base con la propiedad Maven `octoperf.baseUrl`.

### 2. Ejecutar Pruebas desde Línea de Comandos
```bash
mvn clean test
```

Los archivos `.feature` usan las palabras clave de Karate en inglés; los nombres y descripciones de escenarios están en español. El servicio reutilizable envía `username` y `password` como parámetros de consulta, tal como especifica Swagger.

Para validar solo el caso negativo:

```powershell
mvn test "-Dkarate.options=--tags @CasoError"
```

### 3. Generar y Visualizar Reportes
Karate genera automáticamente un reporte HTML interactivo con traza completa de Request/Response HTTP en:
`target/karate-reports/karate-summary.html`

---

## 📂 Estructura del Proyecto

```
karate_project/
├── src/
│   └── test/
│       └── java/
│           ├── karate-config.js               # Configuración global de Karate (Base URL, timeouts)
│           └── com/
│               └── octoperf/
│                   ├── api/                   # Test Suites (Gherkin Features & Runner)
│                   │   ├── octoperf_login.feature
│                   │   └── OctoperfApiTest.java
│                   └── users/                 # Modular Service Objects (POM API)
│                       └── public-user-service.feature
└── pom.xml
```
