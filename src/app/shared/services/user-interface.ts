import { SpotifyUser } from "../models/spotify-user.model"

/*
 Interface for the get User Request
 */
export interface UserRequest {
  userId: string
}

export interface SpotifyUserLoginRequest {
  spotifyUser: SpotifyUser
}

export interface SpotifyUserLogResponse {
  jwt_token: string,
}

export interface TagRequest {
  body: { trackId: number, tag: string }
}