import { Component, OnInit } from '@angular/core';
import { LOCALSTORAGE_TOKEN_KEY } from 'src/app/app.module';
import { Router } from '@angular/router';

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.scss']
})
export class SearchComponent implements OnInit {

  constructor( private router: Router,

    ) { }

  ngOnInit(): void {
  }

  async logout(): Promise<void> {
    localStorage.removeItem(LOCALSTORAGE_TOKEN_KEY);
    this.router.navigate(['../login']);

  }

}
