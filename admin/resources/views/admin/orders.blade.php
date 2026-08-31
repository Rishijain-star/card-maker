@extends('admin.layouts.app')

@section('content')
<div class="stats-grid">
    <div class="stat-card">
        <h3>Total Orders & Plans</h3>
        <div class="value">{{ $orderStats['total'] }}</div>
        <div class="hint">{{ $orders->count() }} Product Orders · {{ $planOrders->count() }} Subscriptions</div>
    </div>
    <div class="stat-card">
        <h3>Successful</h3>
        <div class="value" style="color:var(--green)">{{ $orderStats['successful'] }}</div>
        <div class="hint">Payment completed</div>
    </div>
    <div class="stat-card">
        <h3>Pending</h3>
        <div class="value" style="color:var(--orange)">{{ $orderStats['pending'] }}</div>
        <div class="hint">Awaiting payment</div>
    </div>
    <div class="stat-card">
        <h3>Total Revenue</h3>
        <div class="value">₹{{ number_format($orderStats['revenue']) }}</div>
        <div class="hint">From paid orders & plans</div>
    </div>
</div>

{{-- 1. Product Orders Panel --}}
<div class="panel">
    <div class="panel-head">
        <div>
            <h3 style="margin:0;">Product Cart Orders</h3>
            <span style="font-size:12px; color:var(--muted);">Cards, Lanyards, Badges & Belts placed via Cart Checkout</span>
        </div>
        <span class="badge badge-blue">{{ $orders->count() }} Orders</span>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>Order #</th>
                <th>Customer</th>
                <th>Customized ID Cards / Items</th>
                <th>Qty</th>
                <th>Amount</th>
                <th>Razorpay ID</th>
                <th>Date</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($orders as $order)
                <tr>
                    <td><strong>{{ $order->order_number }}</strong></td>
                    <td>
                        @if ($order->user)
                            <a href="{{ route('admin.users.show', $order->user->id) }}" style="color:var(--blue); font-weight:600;">
                                {{ $order->user->name ?: $order->user->email }}
                            </a>
                            <div style="font-size:11px; color:var(--muted)">{{ $order->user->email }}</div>
                        @else
                            <span style="color:var(--muted)">Guest Customer</span>
                        @endif
                    </td>
                    <td>
                        @php
                            $items = is_array($order->items) ? $order->items : json_decode($order->items, true) ?? [];
                        @endphp
                        @if (!empty($items))
                            @foreach (array_slice($items, 0, 3) as $item)
                                <div style="font-size:12px; line-height:1.4;">
                                    <strong>{{ $item['product_name'] ?? 'ID CARD' }}</strong>
                                    <span style="color:var(--muted)">— {{ $item['design_title'] ?? 'Customized Card' }}</span>
                                    <span style="color:var(--blue); font-weight:600;">({{ $item['size'] ?? 'Standard' }})</span>
                                </div>
                            @endforeach
                            @if (count($items) > 3)
                                <div style="font-size:11px; color:var(--muted); font-weight:600;">
                                    + {{ count($items) - 3 }} more customized cards...
                                </div>
                            @endif
                        @else
                            <span style="color:var(--muted)">ID CARDS</span>
                        @endif
                    </td>
                    <td><strong>{{ $order->total_qty }}</strong></td>
                    <td><strong>₹{{ number_format($order->subtotal) }}</strong></td>
                    <td>
                        <span style="font-family:monospace; font-size:11px; color:var(--muted)">
                            {{ $order->razorpay_payment_id ?? $order->razorpay_order_id }}
                        </span>
                    </td>
                    <td>{{ $order->created_at ? $order->created_at->format('d M Y, h:i A') : '—' }}</td>
                    <td>
                        @php
                            $badge = match ($order->status) {
                                'paid' => 'badge-green',
                                'delivered' => 'badge-green',
                                'created' => 'badge-orange',
                                default => 'badge-gray',
                            };
                        @endphp
                        <span class="badge {{ $badge }}">{{ ucfirst($order->status) }}</span>
                    </td>
                    <td>
                        <div style="display:flex; flex-direction:column; gap:4px;">
                            <a href="{{ route('admin.orders.show', $order->id) }}" style="color:var(--blue); font-weight:600; font-size:12px;">
                                View Cards &rarr;
                            </a>
                            <a href="{{ route('admin.orders.print', $order->id) }}" target="_blank" style="color:var(--green); font-weight:600; font-size:11px;">
                                🖨️ Print Sheet
                            </a>
                        </div>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="9" style="text-align:center; padding: 24px; color:var(--muted)">
                        No product orders placed yet.
                    </td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>

{{-- 2. Premium Plan Subscriptions Panel --}}
<div class="panel" style="margin-top: 24px;">
    <div class="panel-head">
        <div>
            <h3 style="margin:0;">Premium Plan Subscriptions</h3>
            <span style="font-size:12px; color:var(--muted);">Startup (₹118), Basic (₹236), Yearly (₹999) Membership Purchases</span>
        </div>
        <span class="badge badge-green">{{ $planOrders->where('status', 'paid')->count() }} Active Paid</span>
    </div>
    <table class="data-table">
        <thead>
            <tr>
                <th>Receipt / Order</th>
                <th>Customer</th>
                <th>Plan Name</th>
                <th>Save Limit</th>
                <th>Amount Paid</th>
                <th>Razorpay Payment ID</th>
                <th>Date</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($planOrders as $pOrder)
                <tr>
                    <td><strong>#PLAN-{{ $pOrder->id }}</strong></td>
                    <td>
                        @if ($pOrder->user)
                            <a href="{{ route('admin.users.show', $pOrder->user->id) }}" style="color:var(--blue); font-weight:600;">
                                {{ $pOrder->user->name ?: $pOrder->user->email }}
                            </a>
                            <div style="font-size:11px; color:var(--muted)">{{ $pOrder->user->email }}</div>
                        @else
                            <span style="color:var(--muted)">User #{{ $pOrder->user_id }}</span>
                        @endif
                    </td>
                    <td>
                        <span class="badge badge-blue" style="font-weight:700;">
                            {{ strtoupper($pOrder->package_id) }} PLAN
                        </span>
                    </td>
                    <td>
                        @php
                            $limit = match ($pOrder->package_id) {
                                'yearly' => '35,000 Cards',
                                'basic' => '2,500 Cards',
                                'startup' => '500 Cards',
                                default => '5 Cards',
                            };
                        @endphp
                        {{ $limit }}
                    </td>
                    <td><strong>₹{{ number_format($pOrder->amount / 100) }}</strong></td>
                    <td>
                        <span style="font-family:monospace; font-size:11px; color:var(--muted)">
                            {{ $pOrder->razorpay_payment_id ?? $pOrder->razorpay_order_id }}
                        </span>
                    </td>
                    <td>{{ $pOrder->created_at ? $pOrder->created_at->format('d M Y, h:i A') : '—' }}</td>
                    <td>
                        @php
                            $badge = match ($pOrder->status) {
                                'paid' => 'badge-green',
                                'created' => 'badge-orange',
                                default => 'badge-gray',
                            };
                        @endphp
                        <span class="badge {{ $badge }}">{{ ucfirst($pOrder->status) }}</span>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="8" style="text-align:center; padding: 24px; color:var(--muted)">
                        No plan subscriptions purchased yet.
                    </td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>
@endsection
