import { Metadata } from "../models/metadata.model";
import { TaggedTrack } from "../models/tagged-track.model";

export interface SearchTaggedTrackRequest{

    jwt_token : string;

    page : number;

    limit : number;

    tags : string[];

    query : string;

}

export interface SearchTaggedTrackResponse{
    data : TaggedTrack[];
    metadata : Metadata;
}

export interface LikeTaggedTrackRequest{
    jwt_token : string;

    page : number;

    limit : number;
}

export interface LikeTaggedTrackResponse{
    data : TaggedTrack[];
    metadata : Metadata;
}

export interface GetTaggedTrackByTrackIdRequest{
    trackId : number;

    jwt_token : string;
}

export interface GetTagNamesRequest{
    jwt_token : string;
}

export interface GetTagNamesResponse{
    tagNames : string[];
}
