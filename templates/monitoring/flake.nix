#
# Observability & Monitoring Development Environment
#
# Metrics, Logs, Traces, and Alerting Stack
#
{
  description = "Observability & Monitoring Development Environment";

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
            # Metrics Collection & Visualization
            # ============================================

            prometheus           # Metrics database
            alertmanager         # Alert routing
            promtool             # Prometheus CLI tools
            grafana              # Visualization platform
            grafana-loki         # Log aggregation

            # Prometheus Exporters
            prometheus-node-exporter
            prometheus-blackbox-exporter

            # ============================================
            # Distributed Tracing
            # ============================================

            jaeger               # Distributed tracing
            tempo                # Tempo tracing backend

            # ============================================
            # OpenTelemetry
            # ============================================

            opentelemetry-collector  # OTEL collector

            # ============================================
            # Log Management
            # ============================================

            vector               # Log router/aggregator
            fluentd              # Log collector
            logcli               # Loki CLI

            # ============================================
            # Monitoring Tools
            # ============================================

            cadvisor             # Container metrics
            statsd               # Metrics aggregation

            # ============================================
            # Incident Management
            # ============================================

            pagerduty-cli        # PagerDuty CLI

            # ============================================
            # Performance Testing
            # ============================================

            k6                   # Load testing
            vegeta               # HTTP load testing
            hey                  # HTTP load generator

            # ============================================
            # System Monitoring
            # ============================================

            htop                 # Process viewer
            iotop                # I/O monitor
            nethogs              # Network monitor
            sysstat              # System performance

            # ============================================
            # Database Monitoring
            # ============================================

            postgresql           # PostgreSQL client
            redis                # Redis client
            mycli                # MySQL client

            # ============================================
            # Utilities
            # ============================================

            jq                   # JSON processor
            yq-go                # YAML processor
            curl                 # HTTP client
            httpie               # User-friendly HTTP
            grpcurl              # gRPC client

            # Visualization
            graphviz             # Graph rendering
            gnuplot              # Plotting utility
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║     📊 Observability & Monitoring Environment 📊            ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Components:"
            echo ""
            echo "  📈 Metrics Stack:"
            echo "    • Prometheus    $(prometheus --version 2>&1 | head -n1 | awk '{print $3}' || echo 'N/A')"
            echo "    • Grafana       $(grafana-server --version 2>&1 | head -n1 | awk '{print $2}' || echo 'N/A')"
            echo "    • AlertManager  $(alertmanager --version 2>&1 | head -n1 | awk '{print $3}' || echo 'N/A')"
            echo ""
            echo "  📝 Logging Stack:"
            echo "    • Loki          $(loki --version 2>&1 | head -n1 | awk '{print $3}' || echo 'N/A')"
            echo "    • Vector        $(vector --version 2>&1 | awk '{print $2}' || echo 'N/A')"
            echo "    • Fluentd       $(fluentd --version 2>&1 | cut -d' ' -f2 || echo 'N/A')"
            echo ""
            echo "  🔍 Tracing Stack:"
            echo "    • Jaeger        Installed"
            echo "    • Tempo         Installed"
            echo "    • OTEL          Installed"
            echo ""
            echo "🔧 Quick Start Commands:"
            echo ""
            echo "  Start Prometheus:"
            echo "    prometheus --config.file=prometheus.yml"
            echo ""
            echo "  Start Grafana:"
            echo "    grafana-server --homepath /usr/share/grafana"
            echo ""
            echo "  Start Loki:"
            echo "    loki -config.file=loki-config.yml"
            echo ""
            echo "  Query Prometheus:"
            echo "    promtool query instant http://localhost:9090 'up'"
            echo ""
            echo "  Load Testing:"
            echo "    k6 run script.js"
            echo "    vegeta attack -rate=50 -duration=30s | vegeta report"
            echo ""
            echo "💡 Example Configurations:"
            echo "  • Create prometheus.yml, grafana.ini, loki-config.yml"
            echo "  • Check examples/ directory for sample configs"
            echo ""

            export PROJECT_ROOT=$PWD
            export PROMETHEUS_DATA_DIR="$PWD/prometheus-data"
            export GRAFANA_DATA_DIR="$PWD/grafana-data"
            export LOKI_DATA_DIR="$PWD/loki-data"

            mkdir -p "$PROMETHEUS_DATA_DIR" "$GRAFANA_DATA_DIR" "$LOKI_DATA_DIR"
          '';
        };
      });
}
