import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService, AuthStatus } from '../authentication/services/auth.service';
import { Subscription } from 'rxjs';
import { TagService } from '../tags/services/tag.service';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent implements OnInit, OnDestroy {

  showNavbar  = false;

  authSub : Subscription = new Subscription();

  constructor(private router: Router,private readonly authService : AuthService, private readonly tagService : TagService) { 
    
  }
  ngOnDestroy(): void {
    this.authSub.unsubscribe();
  }


  ngOnInit(): void {
    this.authService.currentAuthStatus.subscribe(status=>{
      if(status === AuthStatus.LOGIN){
        this.showNavbar = true;
      }
      if(status === AuthStatus.LOGOUT){
        this.showNavbar = false;
      }
    });
  }

  onTagsClick(){
    this.tagService.lastIdTrackSelected = ''
  }

 
}
