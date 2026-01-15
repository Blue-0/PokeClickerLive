# API Contracts - PokeClickerLive Backend
Generated: 2026-01-15T19:54:01+01:00

## Overview
REST API built with PHP and Supabase.

Base URL: `/api` for local dev or configured production URL.

## Authentication
JWT Header required for private routes: `Authorization: Bearer <token>`

## Endpoints

### Auth

#### POST /api/auth/register
Register a new user.
- **Body:**
  ```json
  { "username": "string", "email": "string", "password": "string" }
  ```
- **Response:**
  ```json
  { 
      "user": { "id": "uuid", "username": "...", "email": "..." }, 
      "token": "jwt_string" 
  }
  ```

#### POST /api/auth/login
Login existing user.
- **Body:**
  ```json
  { "email": "string", "password": "string" }
  ```
- **Response:**
  ```json
  { 
      "user": { "id": "uuid", "username": "...", "email": "..." }, 
      "token": "jwt_string" 
  }
  ```

#### GET /api/auth/me
Get current user info.
- **Auth:** Required
- **Response:** User object

#### POST /api/user/sync
Sync local progress with the cloud.
- **Auth:** Required
- **Body:**
  ```json
  { "last_sync": 123456789, "local_data": {...} }
  ```
- **Response:**
  ```json
  { "server_timestamp": 123456789, "cloud_data": null }
  ```

### Pokemon

#### GET /api/pokemon
List all available Pokémon (Sinnoh Region 387-493).
- **Query:** `?offset=0&limit=20`
- **Response:** List of Pokémon with cached data

#### GET /api/pokemon/{id}
Get details of a specific Pokémon.

#### POST /api/pokemon/catch
Purchase/Catch a Pokémon.
- **Auth:** Required
- **Body:**
  ```json
  { 
      "pokemon_id": 123, 
      "latitude": 12.34, 
      "longitude": 56.78 
  }
  ```
- **Response:**
  - `200 OK`: `{ "message": "Caught ...", "new_balance": 100 }`
  - `402 Payment Required`: Insufficient funds.
  - `404 Not Found`: Pokemon or User not found.

#### GET /api/user/{id}/pokemon
Get a user's inventory.
- **Response:**
  ```json
  {
      "count": 5,
      "total_rps": 12.5,
      "pokemon": [ ... ]
  }
  ```
