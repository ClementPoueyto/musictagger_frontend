import { SpotifyTrackInfo } from "./spotify-track.model";

export interface Track {

    id : string;
  
    spotifyTrack : SpotifyTrackInfo;

    artistName : string;
  
    albumTitle : string;

    artists : string[]

   
    title : string;

   
    image : string;

    duration : number;


}