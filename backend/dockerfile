# Use official Node.js image
FROM node:18

# Install Python 3 and g++ (C++ compiler)
RUN apt-get update && \
    apt-get install -y python3 python3-pip g++

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first for optimized Docker caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy rest of the code
COPY . .

# Expose the port your Node.js backend listens on
EXPOSE 8080

# Start the app
CMD ["npm", "start"]
