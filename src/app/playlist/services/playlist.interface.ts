import { Track } from "src/app/tags/models/track.model";

export interface GetPlaylistsRequest{
    jwt_token : string
}

export interface DeletePlaylistsRequest{
    jwt_token : string;

    playlist_id : number;
}

export interface GetPlaylistByIdRequest{
    jwt_token : string;

    playlist_id : number
}

export interface GetPlaylistTracksByIdRequest{
    jwt_token : string;

    playlist_id : number;

    page : number;

    limit : number;
}

export interface GetPlaylistTracksByIdResponse{
    data : Track[];
    metadata : Metadata;
}

export interface Metadata{
    total : number;

    page  : number;

    limit : number;
}

export interface AddPlaylistsRequest{
    jwt_token : string;

    name :string;

    description : string;

    tags : string[];
}

export interface UpdatePlaylistsRequest{

    playlist_id : number;

    jwt_token : string;

    name :string;

    description : string;

    tags : string[];
}

export interface AddPlaylistBodyRequest{
    playlist:{
        name : string,
        description : string,
        public : boolean,
        collaborative : boolean
        },
        tags: string[]
}