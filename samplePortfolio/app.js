//DATA FOR PORTFOLIO
import { works } from "./data.js";
import { variables } from "./variables.js";
// console.log(works);
/**
 * REFACTORING CREATING A NEW dada.js file to hold all our array data for portfolio
 * adding type module to app.js in index.html, and then importing {works} from ./data.js
 * import to use type module, and include extension .js in your import statement
 */

/**
 * Toggle functionality for main menu
 */
const nameOrder = {
  name: "tobi",
  class: "js3",
};
console.log({ ...nameOrder });

const toggler = document.querySelector(".toggle");
const toggler1 = document.querySelector(".toggle1");
const nav = document.querySelector(".nav_bar");
const header = document.querySelector(".header");
const lightImg = document.querySelector(".nav_logo");
const darkImg = document.querySelector(".nav_logo_one");

//for the hamburger fix, get an SVG icon or use font awesome and just change the color

toggler.addEventListener("click", () => {
  toggler.classList.toggle("toggle_hide");
  toggler1.classList.toggle("toggle1_show");

  if (lightImg.classList.contains("nav_logo")) {
    lightImg.classList.toggle("nav_logo_hide");
  }

  if (darkImg.classList.contains("nav_logo_one")) {
    darkImg.classList.toggle("nav_logo_one_show");
  }

  if (nav.classList.contains("nav_bar")) {
    nav.classList.toggle("nav_bar_show");
  }

  if (header.classList.contains("header")) {
    header.classList.toggle("header_bg_toggle");
  }
});

toggler1.addEventListener("click", () => {
  toggler.classList.toggle("toggle_hide");
  toggler1.classList.toggle("toggle1_show");

  if (lightImg.classList.contains("nav_logo")) {
    lightImg.classList.toggle("nav_logo_hide");
  }

  if (darkImg.classList.contains("nav_logo_one")) {
    darkImg.classList.toggle("nav_logo_one_show");
  }

  if (nav.classList.contains("nav_bar")) {
    nav.classList.toggle("nav_bar_show");
  }

  if (header.classList.contains("header")) {
    header.classList.toggle("header_bg_toggle");
  }
});

const main = document.querySelector("#portfolio_flex");

const testing = () => {
  for (const items of works) {
    const img = document.createElement("IMG");
    const flexItem = document.createElement("div");
    const bgHolder = document.createElement("article");
    const navRedirect = document.createElement("a");
    const p = document.createElement("p");
    const tags = document.createElement("p");
    const i = document.createElement("i");

    img.classList.add("img");
    img.src = items.img;

    navRedirect.href = items.link;
    navRedirect.target = "_blank";
    navRedirect.append(img);

    bgHolder.append(navRedirect);
    bgHolder.classList.add("hold");

    flexItem.appendChild(bgHolder);
    flexItem.classList.add("portfolio_items");

    main.appendChild(flexItem);

    p.textContent = items.title;
    tags.textContent = items.tags;
    flexItem.appendChild(p);
    flexItem.appendChild(tags);
    flexItem.append(i);

    p.classList.add("caption");
    tags.classList.add("tags-caption");
    i.classList.add("fa", "fa-long-arrow-right");
  }
};

testing();

//STICKY NAV

// When the user scrolls the page, execute myFunction
window.onscroll = function () {
  myFunction();
};

// Get the navbar
let navbar = document.querySelector(".header");
let overlay = document.querySelector(".overlay");

// Get the offset position of the navbar
let sticky = navbar.offsetTop;
// console.log(sticky);

// Add the sticky class to the navbar when you reach its scroll position. Remove "sticky" when you leave the scroll position
function myFunction() {
  if (window.pageYOffset >= 600) {
    overlay.classList.add("sticky");
    overlay.classList.add("overlay_show");
    navbar.classList.add("sticky");
  } else {
    overlay.classList.remove("sticky");
    overlay.classList.remove("overlay_show");
    navbar.classList.remove("sticky");
  }
}

//SAMPLE DATA FETCH FOR BTC

// const dataFetch = async () => {
//   try {
//     const data = await fetch("https://api.cryptonator.com/api/ticker/btc-usd");
//     const result = await data.json();
//     const btc = await result.ticker.price;

//     console.log(result);
//     console.log(`Current BTC Price is ${btc}`);

//     const converter = 20 * btc;
//     console.log(`20 BTC equals ${converter} USD`);
//   } catch (error) {
//     console.log(error);
//   }
// };

// dataFetch();
