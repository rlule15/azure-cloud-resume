<script setup>
import { onMounted, ref } from "vue";

const visitorCount = ref(1);
const visitorStatus = ref("loading");

const experience = [
  {
    title: "Infrastructure Code Development Intern",
    eyebrow: "Medica · Minnetonka, MN",
    period: "Jun 2026 – Aug 2026",
    content:
      "Built dependable automation for the systems teams responsible for keeping critical Windows infrastructure healthy.",
    bullets: [
      "Engineered an automated server maintenance pipeline using Azure DevOps and Ansible to execute PowerShell management scripts across target Windows servers.",
      "Refactored PowerShell disk cleanup scripts with DRY principles and structured try/catch handling, reducing codebase length by 15% while improving reliability.",
      "Resolved ServiceNow infrastructure tickets across server provisioning, decommissioning, missing services, and disk space issues through remote administration and PowerShell.",
      "Used VMware vCenter to expand storage volumes and create virtual machine snapshots.",
    ],
  },
  {
    title: "IT Support Specialist Intern",
    eyebrow: "Accra Care LLC · Minnetonka, MN",
    period: "Jun 2025 – Aug 2025",
    content:
      "Supported secure, well-managed endpoint operations across account, device, and hardware lifecycles.",
    bullets: [
      "Provisioned and administered end-user accounts and hardware through Intune, Microsoft 365, and Active Directory.",
      "Managed Windows fleet refreshes and decommissioning for 85% of targeted users.",
      "Worked on a company-wide iPhone refresh for one-third of the organization, coordinating provisioning, migration, and hardware swaps.",
      "Resolved technical escalations in Freshservice while coordinating with third-party hardware vendors.",
    ],
  },
];

const projects = [
  {
    title: "Azure Cloud Resume Challenge",
    eyebrow: "Azure · GitHub Actions · Terraform",
    github: "https://github.com/rlule15/azure-cloud-resume",
    content:
      "A cloud-hosted personal portfolio website with automated CI/CD and infrastructure-as-code deployment.",
    bullets: [
      "Built and managed a cloud environment in Microsoft Azure using Terraform, automating resource setups instead of configuring them manually.",
      "Created a Python backend using Azure Functions and a cloud database to process requests and update website visitor data.",
      "Automated testing and deployments with GitHub Actions, using secure keyless logins (OIDC) so sensitive cloud credentials were never hard coded.",
      "Applied web and network security controls, including HTTPS encryption, Cloudflare DNS routing, and domain access rules (CORS) to prevent unauthorized use.",
    ],
  },
  {
    title: "Automated Event-Driven Self-Healing Pipeline",
    eyebrow: "Datadog · GitHub Actions · Ansible",
    content:
      "An event-driven remediation system that turns infrastructure signals into controlled, repeatable recovery workflows.",
    bullets: [
      "Linked Datadog metric alert webhooks to GitHub Actions to resolve infrastructure anomalies autonomously.",
      "Deployed a self-hosted GitHub Actions runner as a system service on an internal Linux VM without public ingress.",
      "Developed idempotent Ansible playbooks to monitor Docker runtime states and restart crashed containers.",
      "Automated disk capacity remediation by pruning unused Docker objects and dynamically expanding Proxmox VM storage.",
    ],
  },
  {
    title: "Homelab Virtualization & Zero-Trust Network",
    eyebrow: "Proxmox · UniFi · Tailscale · Ansible",
    content:
      "A reproducible homelab platform for secure remote access, service deployment, and infrastructure experimentation.",
    bullets: [
      "Created a reusable Ansible role for Ubuntu VM provisioning through Proxmox Cloud-Init templates.",
      "Automated deployment and lifecycle management for Traefik, n8n, and Uptime Kuma with Docker and Ansible.",
      "Configured Tailscale mesh networking and Traefik with automated TLS certificates, eliminating public port forwarding.",
    ],
  },
];

const skills = [
  {
    label: "Cloud & DevOps",
    items:
      "Azure · Proxmox VE · GitHub Actions · Docker Compose · Ansible · YAML",
  },
  {
    label: "Programming & Scripting",
    items: "C# (.NET) · Python · PowerShell · Bash · SQL",
  },
  {
    label: "Systems & Networking",
    items:
      "Linux · Windows Server · VLANs & Firewalls · Tailscale / Zero Trust · DNS",
  },
];

async function updateVisitorCount() {
  const endpoint = import.meta.env.VITE_VISITOR_FUNCTION_URL;

  if (!endpoint) {
    visitorStatus.value = "offline";
    return;
  }

  try {
    const response = await fetch(endpoint, { method: "GET" });
    if (!response.ok) throw new Error("Visitor endpoint unavailable");

    const payload = await response.json();
    const count = payload.count ?? payload.visitors;
    if (typeof count === "number" && Number.isFinite(count))
      visitorCount.value = count;
    visitorStatus.value = "ready";
  } catch {
    visitorStatus.value = "offline";
  }
}

onMounted(updateVisitorCount);
</script>

<template>
  <main>
    <nav class="site-nav" aria-label="Primary navigation">
      <a class="wordmark" href="#top" aria-label="Rafael Lule home"
        >RL<span>/</span></a
      >
      <div class="nav-links">
        <a href="#experience">Experience</a>
        <a href="#projects">Projects</a>
        <a href="#contact">Contact</a>
      </div>
      <a class="nav-cta" href="mailto:rafael.lule.p@gmail.com"
        >Let's connect <span aria-hidden="true">↗</span></a
      >
    </nav>

    <section id="top" class="hero page-grid" aria-labelledby="hero-title">
      <div class="hero-copy">
        <p class="kicker">
          <span class="status-dot" aria-hidden="true"></span> Cloud &
          infrastructure automation
        </p>
        <h1 id="hero-title">Rafael<br /><em>Lule</em></h1>
        <p class="hero-summary">
          IT & Cloud focused student, passionate about building reliable systems
          through automation and infrastructure code.
        </p>
        <div class="hero-actions">
          <a class="button button-primary" href="#experience"
            >Explore my work <span aria-hidden="true">↓</span></a
          >
          <a class="text-link" href="mailto:rafael.lule.p@gmail.com"
            >Email me <span aria-hidden="true">↗</span></a
          >
        </div>
      </div>
      <div class="hero-aside">
        <div class="location-mark" aria-hidden="true">MN</div>
        <p>Based in<br /><strong>Minnesota, USA</strong></p>
        <p class="hero-note">
          Currently studying Computer Information Technology with a minor in
          Cybersecurity.
        </p>
      </div>
    </section>

    <section class="signal-band" aria-label="Profile highlights"></section>

    <section
      id="experience"
      class="content-section page-grid"
      aria-labelledby="experience-title"
    >
      <div class="section-intro">
        <p class="section-number">01 / 03</p>
        <h2 id="experience-title">Experience</h2>
        <p>
          Hands-on infrastructure work across automation, support, and systems
          operations.
        </p>
      </div>
      <div class="section-body">
        <article
          v-for="role in experience"
          :key="role.title"
          class="resume-entry"
        >
          <div class="entry-meta">
            <span>{{ role.period }}</span
            ><span>{{ role.eyebrow }}</span>
          </div>
          <h3>{{ role.title }}</h3>
          <p class="entry-lede">{{ role.content }}</p>
          <ul>
            <li v-for="bullet in role.bullets" :key="bullet">{{ bullet }}</li>
          </ul>
        </article>
      </div>
    </section>

    <section
      id="projects"
      class="content-section project-section page-grid"
      aria-labelledby="projects-title"
    >
      <div class="section-intro">
        <p class="section-number">02 / 03</p>
        <h2 id="projects-title">Selected projects</h2>
        <p>Personal systems built to learn by shipping the whole loop.</p>
      </div>
      <div class="section-body project-list">
        <article
          v-for="project in projects"
          :key="project.title"
          class="project-entry"
        >
          <div class="project-index">0{{ projects.indexOf(project) + 1 }}</div>
          <p class="project-tools">{{ project.eyebrow }}</p>
          <div class="project-heading-row">
            <h3>{{ project.title }}</h3>
            <a
              v-if="project.github"
              :href="project.github"
              target="_blank"
              rel="noreferrer"
              class="project-link"
              >View on GitHub <span aria-hidden="true">↗</span></a
            >
          </div>
          <div>
            <p class="entry-lede">{{ project.content }}</p>
            <ul>
              <li v-for="bullet in project.bullets" :key="bullet">
                {{ bullet }}
              </li>
            </ul>
          </div>
        </article>
      </div>
    </section>

    <section
      class="content-section skills-section page-grid"
      aria-labelledby="skills-title"
    >
      <div class="section-intro">
        <p class="section-number">03 / 03</p>
        <h2 id="skills-title">Toolkit</h2>
        <p>The tools I use to move from idea to reliable operation.</p>
      </div>
      <div class="skills-list">
        <div v-for="skill in skills" :key="skill.label" class="skill-row">
          <h3>{{ skill.label }}</h3>
          <p>{{ skill.items }}</p>
        </div>
      </div>
    </section>

    <footer id="contact" class="site-footer page-grid">
      <div>
        <h2>Let's <br /><em>connect.</em></h2>
      </div>
      <div class="footer-links">
        <a href="mailto:rafael.lule.p@gmail.com"
          >Email <span aria-hidden="true">↗</span></a
        ><a href="https://www.linkedin.com/in/rafael-lule-2bb458302" target="_blank" rel="noreferrer"
          >LinkedIn <span aria-hidden="true">↗</span></a
        >
        <a
          href="https://github.com/rlule15"
          target="_blank"
          rel="noreferrer"
          >GitHub <span aria-hidden="true">↗</span></a
        >
        <p class="visitor-count">
          <span
            class="count-dot"
            :class="{ live: visitorStatus === 'ready' }"
            aria-hidden="true"
          ></span
          >{{ visitorCount.toLocaleString() }} visitors
        </p>
      </div>
      <p class="footer-bottom">
        © 2026 Rafael Lule <span>Built for the systems behind the screen.</span>
      </p>
    </footer>
  </main>
</template>
