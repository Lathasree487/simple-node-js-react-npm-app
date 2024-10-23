# Use Node.js LTS version as the base image
FROM node:lts-buster-slim

# Set the working directory inside the container to /opt
WORKDIR /opt

# Copy all files from the host to the container's working directory
COPY . .

# Install dependencies using npm
RUN npm install

# Expose port 3000
EXPOSE 3000

# Run the application using npm start
CMD ["npm", "start"]
