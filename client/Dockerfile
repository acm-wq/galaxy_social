FROM node:23-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy application code
COPY . .

# Build the app
RUN npm run build

# Expose port
EXPOSE 3000

# Start the Next.js server
CMD ["npm", "start"]