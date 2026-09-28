# ==============================================================================
# Backend Dockerfile - product-api (Spring Boot 3 / Java 17)
# Multi-stage build: builder (Maven) -> runtime (JRE slim, usuario no root)
# ==============================================================================

# ---------- Stage 1: Builder ----------
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
WORKDIR /app

# Copiamos primero el pom.xml para aprovechar la cache de capas de Docker:
# si las dependencias no cambian, este paso no se vuelve a ejecutar.
COPY pom.xml .
RUN mvn -B dependency:go-offline

# Copiamos el código fuente y compilamos el artefacto (los tests ya se
# ejecutan en el job "test-backend" del pipeline de CI).
COPY src ./src
RUN mvn -B package -DskipTests

# ---------- Stage 2: Runtime ----------
FROM eclipse-temurin:17-jre-alpine AS runtime
WORKDIR /app

# Usuario no root por buenas prácticas de seguridad
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/target/*.jar app.jar

RUN chown appuser:appgroup app.jar
USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
