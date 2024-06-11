# Dockerfile per al servidor FastAPI (Python)
# Utilitza la imatge oficial de Python com a base
FROM mcr.microsoft.com/windows:20H2
FROM python:3.11

# Directori de treball
WORKDIR /app

# Copia els arxius del servidor FastAPI (main.py) al contenidor
COPY ./Backend /app

# Instal·la les dependencies
RUN pip install -r requirements.txt

# Inicia el servidor FastAPI
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

# Dockerfile per a l'aplicació Flutter (Dart)
# Utilitza la imatge oficial de Flutter com a base
FROM instrumentisto/flutter

# Directori de treball
WORKDIR /app

# Copia els arxius de l'aplicació Flutter al contenidor
COPY ./Frontend/taskmanager /app

# Instal·la les dependencies Flutter
RUN flutter pub get

# Inicia l'aplicació Flutter
CMD ["flutter", "run", "-d", "all"]