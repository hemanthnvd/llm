# Use the official Python image from the Docker Hub
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies
RUN apt-get update && apt-get install -y wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh

# Add conda to path
ENV PATH="/opt/conda/bin:${PATH}"

# Create conda environment
RUN conda create -n env_langchain1 python=3.10 -y

# Ensure the conda environment is activated for all subsequent RUN commands
SHELL ["conda", "run", "-n", "env_langchain1", "/bin/bash", "-c"]

# Install packages
RUN conda install jupyter -y && \
    pip install --upgrade pip && \
    conda install pytorch torchvision torchaudio cpuonly -c pytorch -y && \
    pip install transformers sentence-transformers langchain langchain_community langchain-huggingface \
    langchain_experimental langchainhub pinecone-client groq langchain_pinecone langchain_groq flask

# Expose the port that the Flask app will run on
EXPOSE 5000

# Define environment variables
ENV FLASK_ENV=production

# Command to run the Flask app
CMD ["python", "app.py"]
