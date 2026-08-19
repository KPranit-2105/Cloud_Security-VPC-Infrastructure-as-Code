# Organization Standard: Network Architecture & Micro-segmentation
**Document ID:** STD-NET-SEC-01  
**Organization:** Apex Cloud Financial Systems (ApexPay)  
**Standard Mapping:** PCI-DSS v4.0 Requirement 1.2 / 1.3, CIS AWS 5.x  

---

## 1. Network Zoning & Controls
1. **Multi-Tier Subnet Isolation:** Web, Application, and Database tiers must be housed in isolated VPC subnets with explicit Network Access Control Lists (NACLs).
2. **Cardholder Data Environment (CDE) Isolation:** Database subnets hosting payment tokens must have no direct Internet Gateway (IGW) route and zero outbound internet egress.
3. **No Direct SSH (Port 22):** Direct inbound SSH access from `0.0.0.0/0` is strictly forbidden. Administrative access must be routed through AWS SSM Session Manager with full CLI session logging enabled.
