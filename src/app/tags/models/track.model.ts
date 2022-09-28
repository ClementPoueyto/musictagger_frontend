import { SpotifyTrackInfo } from "./spotify-track.model";

export interface Track {

    id : number;
  
    spotifyTrack : SpotifyTrackInfo;

    artistName : string;
  
    albumTitle : string;

    artists : string[]

   
    title : string;

   
    image : string;

    duration : number;


}