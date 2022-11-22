import { Directive, ElementRef } from "@angular/core";
import { TagService } from "../services/tag.service";

@Directive({
    selector: '[track-scroll]',
    host: { '(window:scroll)': 'track($event)' }
})

export class TrackScrollDirective {

    constructor(private el: ElementRef, private tagService: TagService) {
    }

    track($event: Event) {
        this.tagService.offsetScroll = window.pageYOffset
    }

}