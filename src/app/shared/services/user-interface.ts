import { SpotifyUser } from "../models/spotify-user.model"

/*
 Interface for the get User Request
 */
export interface UserRequest {
  userId: string
}

export interface SpotifyUserLoginRequest {
  jwt_token: string,
  spotifyUser: SpotifyUser
}

export interface SpotifyUserLogResponse {
  jwt_token: string,
}

export interface TagRequest {
  jwt_token: string,
  body: { trackId: number, tag: string }
}