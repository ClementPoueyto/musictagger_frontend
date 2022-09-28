import { SpotifyPlaylist } from "./spotify-playlist.model";

export interface Playlist{
    id: string;

    userId : string

    name : string

    description : string

    spotifyPlaylist : SpotifyPlaylist;

    tags : string[]
}