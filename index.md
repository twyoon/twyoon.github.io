---
layout: onepage
sections:
  - { id: about, label: About }
  - { id: research, label: Research }
  - { id: education, label: Education }
  - { id: experience, label: Experience }
  - { id: publications, label: Publications }
  - { id: presentations, label: Presentations }
  - { id: skills, label: Skills }
  - { id: teaching, label: Teaching }
  - { id: awards, label: Awards }
---

<section id="about" class="about-container">
    <div class="profile-image">
        <img src="./assets/yoon_mono_web.jpg" alt="Taewoong Yoon" class="responsive-image">
    </div>
    <div class="profile-text">
        <p>
            I am Taewoong Yoon, a Ph.D. candidate advised by <strong><a href="https://choigroup.snu.ac.kr" target="_blank">Prof.&nbsp;Hyunyong Choi</a></strong>
            in the Department of Physics and Astronomy at <strong>Seoul National University</strong>.
            I also work with <strong><a href="https://sites.google.com/view/pauleegroup" target="_blank">Dr.&nbsp;Junghyun Lee</a></strong>
            at the <strong>Korea Institute of Science and Technology (KIST)</strong>. I expect to complete my Ph.D. in February 2027 and am seeking a postdoctoral position.
        </p>
        <p>
            My research focuses on coherent control of <strong>solid-state spin defects</strong>, in particular
            nitrogen-vacancy (NV) and substitutional nitrogen (P1) centers in diamond, and on the interactions and
            polarization dynamics among these spin ensembles.
            I built my group's first NV measurement setup, from the confocal optics and microwave hardware
            to the control and data acquisition software, which served as the platform for my doctoral research.
        </p>
    </div>
</section>

<section id="research" class="research-section">
    <h2>Research</h2>

    <div class="research-item">
        <div class="research-figure">
            <a href="./assets/research_figs/Slide1.png" target="_blank"><img src="./assets/research_figs/Slide1.png" alt="Repeated NV-to-P1 polarization transfer, P1 polarization buildup, and collective Rabi oscillation"></a>
        </div>
        <div class="research-text">
            <h3>Mesoscopic spin coherence in a disordered dark electron spin ensemble</h3>
            <p>
                P1 centers are optically dark and lack a direct optical initialization pathway. By iteratively
                transferring polarization from optically initialized NV centers, I polarized the P1
                ensemble to 740 times its thermal-equilibrium value and characterized its collective
                coherent dynamics.
            </p>
            <p class="research-links">
                <a href="https://doi.org/10.48550/arXiv.2602.17074" target="_blank">arXiv:2602.17074</a> (2026)
            </p>
        </div>
    </div>

    <div class="research-item">
        <div class="research-figure">
            <a href="./assets/research_figs/Slide2.png" target="_blank"><img src="./assets/research_figs/Slide2.png" alt="P1-P1 DEER sequence and measured spectra between spectrally resolved P1 subensembles"></a>
        </div>
        <div class="research-text">
            <h3>Controlled polarization exchange between P1 subensembles</h3>
            <p>
                I demonstrated controlled polarization transfer between spectrally resolved P1 subensembles by extending
                the NV&ndash;P1 protocols to interactions within the P1 ensemble.
            </p>
        </div>
    </div>

    <div class="research-item">
        <div class="research-figure">
            <a href="./assets/research_figs/Slide3.png" target="_blank"><img src="./assets/research_figs/Slide3.png" alt="Identification of NV axes from spatially varying microwave fields"></a>
        </div>
        <div class="research-text">
            <h3>Vector magnetometry with NV ensembles</h3>
            <p>
                NV centers in an ensemble are oriented along four crystallographic axes, and
                reconstructing a vector magnetic field requires assigning each resonance to its axis.
                I identified the axes from a spatially varying microwave field, which enables vector
                magnetometry without a calibrated bias field.
            </p>
            <p class="research-links">
                <a href="https://doi.org/10.1063/5.0243162" target="_blank"><em>Applied Physics Letters</em> <strong>126</strong>, 144002 (2025)</a>
            </p>
        </div>
    </div>

    <div class="research-item">
        <div class="research-figure">
            <a href="./assets/research_figs/Slide4.png" target="_blank"><img src="./assets/research_figs/Slide4.png" alt="Single-pulse femtosecond laser writing setup and written single color centers"></a>
        </div>
        <div class="research-text">
            <h3>Femtosecond laser writing of color centers</h3>
            <p>
                I created site-controlled single color centers in diamond and hexagonal boron nitride,
                confirmed by photon antibunching, using a home-built single-pulse femtosecond
                laser-writing system with aberration correction.
            </p>
        </div>
    </div>
</section>

{% include cv_section.html id="education" heading="Education" %}
{% include cv_section.html id="experience" heading="Research Experience" %}

<section id="publications" class="cv-section">
    <h2>Publications</h2>
    {% capture publications %}{% include publications.md %}{% endcapture %}
    {{ publications | markdownify }}
</section>

{% include cv_section.html id="presentations" heading="Presentations" %}
{% include cv_section.html id="skills" heading="Technical Skills" %}
{% include cv_section.html id="teaching" heading="Teaching Experience" %}
{% include cv_section.html id="awards" heading="Honors and Awards" %}
