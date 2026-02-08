#
# SRE (Site Reliability Engineering) Toolkit
#
# Database management, backup/restore, performance testing, incident response
#
{
  description = "SRE Toolkit Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # ============================================
            # Database Clients & Management
            # ============================================

            # PostgreSQL
            postgresql           # PostgreSQL client (psql)
            pgcli                # Enhanced PostgreSQL CLI

            # MySQL/MariaDB
            mysql80              # MySQL client
            mycli                # Enhanced MySQL CLI

            # Redis
            redis                # Redis client

            # MongoDB
            mongosh              # MongoDB Shell

            # ============================================
            # Backup & Restore Tools
            # ============================================

            restic               # Modern backup tool
            rclone               # Cloud storage sync
            borgbackup           # Deduplicating backup

            # Database-specific backup
            # pgbackrest is available for PostgreSQL

            # ============================================
            # Performance Testing & Benchmarking
            # ============================================

            sysbench             # System performance benchmark

            # Load Testing
            k6                   # Modern load testing
            vegeta               # HTTP load testing
            hey                  # HTTP load generator
            wrk                  # HTTP benchmarking

            # ============================================
            # Monitoring & Observability
            # ============================================

            prometheus           # Metrics collection
            grafana              # Metrics visualization
            promtool             # Prometheus CLI

            # System monitoring
            htop                 # Process viewer
            iotop                # I/O monitor
            nethogs              # Network monitor
            sysstat              # System statistics

            # ============================================
            # Incident Response & Debugging
            # ============================================

            strace               # System call tracer
            ltrace               # Library call tracer
            gdb                  # GNU debugger
            tcpdump              # Network packet analyzer
            wireshark            # Network protocol analyzer
            mtr                  # Network diagnostics

            # ============================================
            # Log Analysis
            # ============================================

            logcli               # Loki log CLI
            angle-grinder        # Log parsing/analysis

            # ============================================
            # Chaos Engineering
            # ============================================

            # Note: chaos-mesh requires cluster installation
            # toxiproxy is available as a proxy for chaos testing

            # ============================================
            # Kubernetes Tools
            # ============================================

            kubectl              # Kubernetes CLI
            k9s                  # K8s terminal UI
            stern                # Multi-pod log tailing
            velero               # K8s backup/restore

            # ============================================
            # Alert Management
            # ============================================

            alertmanager         # Prometheus alert routing
            pagerduty-cli        # PagerDuty CLI

            # ============================================
            # Documentation & Postmortems
            # ============================================

            pandoc               # Document converter

            # ============================================
            # Utilities
            # ============================================

            jq                   # JSON processor
            yq-go                # YAML processor
            fzf                  # Fuzzy finder
            ripgrep              # Fast grep
            bat                  # Better cat
            curl                 # HTTP client
            httpie               # User-friendly HTTP

            # Time utilities
            dateutils            # Date/time tools

            # Text processing
            gawk                 # AWK text processing
            gnused               # Stream editor
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║              🛠️  SRE Toolkit Environment 🛠️                 ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Components:"
            echo ""
            echo "  💾 Database Clients:"
            echo "    • PostgreSQL: $(psql --version 2>&1 | awk '{print $3}' || echo 'N/A')"
            echo "    • MySQL:      $(mysql --version 2>&1 | awk '{print $5}' | cut -d',' -f1 || echo 'N/A')"
            echo "    • Redis:      $(redis-cli --version 2>&1 | awk '{print $2}' || echo 'N/A')"
            echo "    • MongoDB:    $(mongosh --version 2>&1 || echo 'N/A')"
            echo ""
            echo "  📊 Monitoring:"
            echo "    • Prometheus: $(prometheus --version 2>&1 | head -n1 | awk '{print $3}' || echo 'N/A')"
            echo "    • Grafana:    $(grafana-server --version 2>&1 | awk '{print $2}' || echo 'N/A')"
            echo ""
            echo "  🔧 Performance Testing:"
            echo "    • k6:         $(k6 version 2>&1 | head -n1 || echo 'N/A')"
            echo "    • vegeta:     $(vegeta -version 2>&1 || echo 'N/A')"
            echo "    • sysbench:   $(sysbench --version 2>&1 | awk '{print $2}' || echo 'N/A')"
            echo ""
            echo "🔧 Common SRE Tasks:"
            echo ""
            echo "  Database Operations:"
            echo "    pgcli -h localhost -U user -d database"
            echo "    mycli -h localhost -u user -D database"
            echo "    redis-cli -h localhost -p 6379"
            echo ""
            echo "  Backup & Restore:"
            echo "    restic init --repo /backup"
            echo "    restic backup /data"
            echo "    restic restore latest --target /restore"
            echo ""
            echo "  Performance Testing:"
            echo "    k6 run load-test.js"
            echo "    vegeta attack -rate=100 -duration=60s | vegeta report"
            echo "    sysbench cpu run"
            echo ""
            echo "  Incident Response:"
            echo "    kubectl logs -f <pod> | grep ERROR"
            echo "    stern <app> --since 15m"
            echo "    tcpdump -i any port 80"
            echo ""
            echo "  System Monitoring:"
            echo "    htop"
            echo "    iotop"
            echo "    nethogs"
            echo ""
            echo "💡 SRE Best Practices:"
            echo "  1. Monitor everything (metrics, logs, traces)"
            echo "  2. Automate toil (repetitive operational tasks)"
            echo "  3. Set SLOs and error budgets"
            echo "  4. Write postmortems for incidents"
            echo "  5. Practice chaos engineering"
            echo ""

            export PROJECT_ROOT=$PWD
            export BACKUP_DIR="$PWD/backups"
            export INCIDENT_LOGS="$PWD/incident-logs"

            mkdir -p "$BACKUP_DIR" "$INCIDENT_LOGS"
          '';
        };
      });
}
