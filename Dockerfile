FROM python:3.10-slim

WORKDIR /app

# Install system-level dependencies required for some Python packages (like wordcloud, Pillow, etc.)
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libgomp1 \
    libffi-dev \
    libssl-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libfreetype6-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy requirements first (for caching efficiency)
COPY requirements.txt /app/requirements.txt

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the application code
COPY flask_app/ /app/
COPY tfidf_vectorizer.pkl /app/tfidf_vectorizer.pkl

# Download NLTK data
RUN python -m nltk.downloader stopwords wordnet

# Expose port 8000 for Flask
EXPOSE 8000

# Start Flask app
CMD ["python", "app.py"]
