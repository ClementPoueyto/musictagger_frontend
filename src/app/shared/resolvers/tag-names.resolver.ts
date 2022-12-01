import { Injectable } from "@angular/core";
import { ActivatedRouteSnapshot, Resolve, Router, RouterStateSnapshot } from "@angular/router";
import { Observable, of } from "rxjs";
import { TagService } from "src/app/tags/services/tag.service";

@Injectable({
    providedIn: 'root',
  })
  export class SiteSettingResolver implements Resolve<any> {
    constructor(private readonly tagService : TagService,
                private router: Router) {
    }
  
    resolve(
      route: ActivatedRouteSnapshot,
      state: RouterStateSnapshot
    ): Observable<{ tagNames: string[] }> {
        return of();
      
    }
  }