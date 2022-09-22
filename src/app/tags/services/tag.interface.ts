import { Metadata } from "../models/metadata.model";
import { TaggedTrack } from "../models/tagged-track.model";

export interface SearchTaggedTrackRequest{

    jwt_token : string;

    page : number;

    tags : string[];

    query : string;

}

export interface SearchTaggedTrackResponse{
    data : TaggedTrack[]
    metadata : Metadata
}