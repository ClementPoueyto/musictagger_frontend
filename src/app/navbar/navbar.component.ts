import { Component, Input, OnInit, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService, AuthStatus } from '../authentication/services/auth.service';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-navbar',
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss']
})
export class NavbarComponent implements OnInit, OnDestroy {

  showNavbar : boolean = false;

  authSub : Subscription = new Subscription();

  constructor(private router: Router,private readonly authService : AuthService) { 
    
  }
  ngOnDestroy(): void {
    this.authSub.unsubscribe();
  }


  ngOnInit(): void {
    this.authService.currentAuthStatus.subscribe(status=>{
      if(status == AuthStatus.LOGIN){
        this.showNavbar = true;
      }
      if(status == AuthStatus.LOGOUT){
        this.showNavbar = false;
      }
    });
  }

 
}
