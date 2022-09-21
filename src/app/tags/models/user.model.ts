import { SpotifyUser } from "./spotify-user.model";

export interface User {
    id: string;
  
    email: string;
  
    password?: string;
  
    firstname?: string;
  
    lastname?: string;
  
    createdAt: Date;
  
    updatedAt: Date;
  
    isRegisteredWithGoogle: boolean;
  
    spotifyUser?: SpotifyUser;
  
    lastLoginAt: Date;
  
  }