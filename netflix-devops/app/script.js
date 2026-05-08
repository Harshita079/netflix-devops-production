document.addEventListener("DOMContentLoaded", () => {

    console.log("Netflix DevOps Project Loaded Successfully");

    const playButton = document.querySelector(".play-btn");

    const infoButton = document.querySelector(".info-btn");

    playButton.addEventListener("click", () => {

        alert("Playing Netflix DevOps Demo!");

    });

    infoButton.addEventListener("click", () => {

        alert("Production-Style CI/CD Pipeline using Terraform, Jenkins, Docker, and AWS.");

    });

    const footer = document.createElement("div");

    footer.style.position = "absolute";
    footer.style.bottom = "20px";
    footer.style.width = "100%";
    footer.style.textAlign = "center";
    footer.style.color = "white";
    footer.style.fontSize = "14px";

    footer.innerHTML =
        "Last Deployment: " + new Date().toLocaleString();

    document.body.appendChild(footer);

});