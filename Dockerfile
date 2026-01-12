# =========================
# STAGE 1: Build the app
# =========================
FROM maven:3.9.6-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy only pom.xml first (for caching)
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests


# =========================
# STAGE 2: Run the app
# =========================
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy only the built JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

