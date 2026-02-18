# Testing & Validation – Zoho People API (Google Colab)

This document captures the validation steps performed before implementing the integration in Power BI.

The objective was to confirm:

- OAuth 2.0 authentication flow
- Regional endpoint correctness (`zoho.in`)
- API permission validation
- JSON response structure
- Data transformation feasibility

---

## Environment

- Google Colab
- Python
- requests library
- pandas library

---

## Cell 1 – Import Libraries

```python
import requests
import pandas as pd
