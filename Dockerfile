FROM node:22-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY app/package*.json ./
RUN npm ci

COPY app/ .

EXPOSE 3001

CMD ["npx", "tsx", "src/serve.ts"]
