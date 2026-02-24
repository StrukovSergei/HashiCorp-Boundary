
# 📄 setup-guide.md

# 🛠 HashiCorp Boundary Zero Trust – Full Setup Guide

This guide walks through the complete setup:

- Controller
- Worker
- Database
- Targets
- Roles
- User creation
- Required grants

Environment used:

- Ubuntu 22 (Boundary Controller + Worker)
- PostgreSQL
- OPNsense firewall
- Windows SQL Server (LAN only)

---

# 1️⃣ Install Boundary

```bash
sudo apt update
sudo apt install boundary
````

Verify:

```bash
boundary version
```

---

# 2️⃣ Configure PostgreSQL

Create DB and user:

```bash
sudo -u postgres psql
```

```sql
CREATE DATABASE boundary;
CREATE USER boundary WITH PASSWORD 'StrongPassword';
GRANT ALL PRIVILEGES ON DATABASE boundary TO boundary;
```

Exit with `\q`.

---

# 3️⃣ Controller Configuration

Create:

```
/etc/boundary/controller.hcl
```

---

# 4️⃣ Initialize Database

```bash
boundary database init -config /etc/boundary/controller.hcl
```

Save the generated admin credentials.

---

# 5️⃣ Start Controller

```bash
boundary server -config /etc/boundary/controller.hcl
```

---

# 6️⃣ Worker Configuration

Create:

```
/etc/boundary-worker.hcl
```

Start worker:

```bash
boundary server -config /etc/boundary-worker.hcl
```

---

# 7️⃣ Firewall Requirements

Allow from Internet:

* TCP 9200 (Controller API)
* TCP 9202 (Worker proxy)

Block:

* Everything else

---

# 8️⃣ Create Target (GUI)

Project → Targets → New Target

SQL:

* Name: `sql-1433`
* Type: Generic TCP
* Address: 172.16.0.10
* Port: 1433

RDP:

* Name: `rdp-sql-server`
* Type: Generic TCP
* Address: 172.16.0.10
* Port: 3389

---

# 9️⃣ Create User

Global → Users → New

* Login name: `sql-user`
* Set password

---

# 🔟 Create Role (Project Scope)

Project → Roles → New

Attach:

* Principal → select user

---

# 1️⃣1️⃣ Required Grants

Inside role → Grants → Add:

```
type=target;ids=ttcp_RDP_TARGET_ID;actions=read,authorize-session
type=target;actions=list
```

Explanation:

* `read` → allows viewing target
* `authorize-session` → allows starting session
* `list` → allows target to appear in UI

Without `list`, target will not show.

---

# 1️⃣2️⃣ Connect

Authenticate:

```bash
boundary authenticate password
```

Start tunnel:

```bash
boundary connect tcp -target-id ttcp_RDP_TARGET_ID
```

Connect RDP client to:

```
127.0.0.1:<generated_port>
```

---

# ✅ Validation Checklist

* Worker shows as active in UI
* Target visible to user
* Session status becomes Active
* RDP connects successfully
* SQL connects successfully

---

# 🔐 Security Notes

* Internal services are never exposed
* No full LAN access granted
* Access controlled per user, per session
* Revocation = remove user from role

